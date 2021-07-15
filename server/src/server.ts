import * as express from 'express';
import * as http from 'http';
import * as WebSocket from 'ws';

const PORT = process.env.PORT || 3000;

const app = express();

//initialize a simple http server
const server = http.createServer(app);

//initialize the WebSocket server instance
const wss = new WebSocket.Server({ server });

wss.on('connection', (ws: WebSocket, request: http.IncomingMessage) => {
    ws.onopen = function(event: WebSocket.OpenEvent) {
        console.log('connection open');
    };

    //Handle incoming messages
    ws.onmessage = function(event: WebSocket.MessageEvent)  {

        //log the received message and send it back to the client
        console.log('received: %s', event.data);
        ws.send(`You sent: ${event.data}`);
    };

    ws.onerror = function(event: WebSocket.ErrorEvent) {
        console.log('error: %s', event.error);
    };

    ws.onclose = function(event: WebSocket.CloseEvent) {
        console.log('connection closed');
    };

    //log and send a message to the new connection
    console.log('new connection from %s', request.socket.remoteAddress);    
    ws.send('Hi there, I am a WebSocket server');
});

//start server
server.listen(PORT, () => {
    console.log(`> Server started on port ${PORT}`);
});