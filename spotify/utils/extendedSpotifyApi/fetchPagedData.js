async function fetchPagedData(api, method, { requiredArgs = [], options }, { onData, onEnd }) {
  const limit = 50;
  let offset = 0;

  while (true) {
    const data = await api[method](...[...requiredArgs, { ...options, offset, limit }]);
    if (!data.body?.items?.length) {
      onEnd();
      break;
    }
    onData(data.body.items);
    offset += limit;
  }
}

module.exports.fetchPagedData = fetchPagedData;
