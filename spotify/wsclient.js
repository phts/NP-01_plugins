// import WebSocket from 'ws';
const websocket = require('ws');

const ws = new websocket('ws://localhost:9876/events');

ws.on('error', function (error) {
  console.error(error);
});

ws.on('open', function open() {
  ws.send('something');
});

ws.on('message', function message(data) {
  console.log('received: %s', data);
});
