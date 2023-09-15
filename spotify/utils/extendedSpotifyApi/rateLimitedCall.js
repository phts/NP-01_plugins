const libQ = require('kew');

const COOLDOWN_PERIOD = 10;
const MAX_ATTEMPTS = 10;

let onPause = false;
let pauseTimeoutRef = null;

function pauseAllRequests() {
  clearTimeout(pauseTimeoutRef);
  onPause = true;
  pauseTimeoutRef = setTimeout(() => {
    onPause = false;
  }, COOLDOWN_PERIOD * 1000);
}

function waitForCooldown() {
  return new Promise((resolve) => {
    if (!onPause) {
      resolve();
      return;
    }
    const int = setInterval(() => {
      if (!onPause) {
        clearInterval(int);
        resolve();
      }
    }, 1000);
  });
}

function call(api, method, { logger, args, attempt } = {}) {
  if (attempt > MAX_ATTEMPTS) {
    return Promise.reject(new Error(`Too many attempts (>${MAX_ATTEMPTS})`));
  }

  return new Promise(async (resolve, reject) => {
    try {
      await waitForCooldown();
      const data = await api[method](...args);
      resolve(data);
    } catch (e) {
      if (e.statusCode === 429) {
        logger.warn(
          `Spotify API method ${method} failed due to "Too many requests". Stop all API requests for ${COOLDOWN_PERIOD} seconds.`
        );
        pauseAllRequests();
        call(api, method, { logger, args, attempt: attempt + 1 })
          .then((x) => resolve(x))
          .catch((x) => reject(x));
        return;
      }
      reject(new Error(`Spotify API method ${method} failed: ${e}`));
    }
  });
}

module.exports.rateLimitedCall = call;
