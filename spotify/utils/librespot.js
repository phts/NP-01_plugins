const {exec} = require('child_process');
const Websocket = require('ws');

module.exports.Librespot = class Librespot {
  constructor({port, configPath, service, onOpen, onMessage, logger}) {
    this.configPath = configPath;
    this.apiBaseUrl = `http://127.0.0.1:${port}`;
    this._websocket = null;
    this._status = 'stopped';
    this._restartTimeout = null;
    this._port = port;
    this._service = service;
    this._onOpen = onOpen;
    this._onMessage = onMessage;
    this._logger = logger;
  }

  async start() {
    await this._startDaemon();
    this._startWebsocket();
  }

  async stop() {
    this._stopWebsocket();
    await this._stopDaemon();
  }

  _startWebsocket() {
    this._initConnection();
    this._status = 'started';
  }

  _stopWebsocket() {
    this._terminateConnection();
    this._status = 'stopped';
  }

  _restartWebsocket() {
    if (this._status !== 'started') {
      return;
    }
    clearTimeout(this._restartTimeout);
    this._restartTimeout = setTimeout(() => {
      this._initConnection();
      this._restartTimeout = null;
      this._status = 'started';
    }, 3000);
  }

  _initConnection() {
    this._terminateConnection();
    this._logger.info('Initializing connection to go-librespot websocket');

    const w = new Websocket('ws://localhost:' + this._port + '/events');
    w.on('error', (error) => {
      this._logger.info(`Error connecting to go-librespot websocket: ${error}`);
      this.restartWebsocket();
    });
    w.on('message', (data) => {
      this._onMessage(JSON.parse(data));
    });
    w.on('open', () => {
      this._logger.info('Connection to go-librespot websocket established');
      if (this._onOpen) {
        this._onOpen();
      }
    });
    w.on('close', () => {
      this._logger.info(`Connection to go-librespot websocket closed`);
    });

    this._websocket = w;
  }

  _terminateConnection() {
    this._logger.info('Terminate connection to go-librespot websocket');
    if (!this._websocket) {
      return;
    }
    this._websocket.terminate();
    this._websocket = undefined;
  }

  _startDaemon() {
    return new Promise((resolve, reject) => {
      exec(`/usr/bin/sudo systemctl restart ${this._service}`, (error) => {
        if (error) {
          this._logger.error(`Cannot start ${this._service} daemon: ${error}`);
          reject(error);
        } else {
          setTimeout(() => {
            this._logger.info(`${this._service} daemon successfully started`);
            resolve();
          }, 3000);
        }
      });
    });
  }

  _stopDaemon() {
    return new Promise((resolve, reject) => {
      exec(`/usr/bin/sudo systemctl stop ${this._service}`, (error) => {
        if (error) {
          this._logger.error(`Cannot stop ${this._service} daemon: ${error}`);
          reject(error);
        } else {
          setTimeout(() => {
            resolve();
          }, 2000);
        }
      });
    });
  }
};
