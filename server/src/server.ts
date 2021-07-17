import * as express from 'express';
import { createServer, IncomingMessage } from 'http';
import * as WebSocket from 'ws';

const PORT = process.env.PORT || 3000;

var message_list: string[] = [];

const app = express();

//initialize a simple http server
const server = createServer(app);

//initialize the WebSocket server instance
const wss = new WebSocket.Server({ server });

wss.on('connection', (ws: WebSocket, request: IncomingMessage) => {
    ws.onopen = function(event: WebSocket.OpenEvent) {
        console.log('Connection open');
    };

    //handle incoming messages
    ws.onmessage = function(event: WebSocket.MessageEvent)  {

        //log the received message and send it back to the client
        console.log('Received: %s', event.data);
        message_list.push(`From You: ${event.data}`);
        console.log(message_list);
        ws.send(JSON.stringify(message_list));
    };

    ws.onerror = function(event: WebSocket.ErrorEvent) {
        console.log('Error: %s', event.error);
    };

    ws.onclose = function(event: WebSocket.CloseEvent) {
        console.log('Connection closed');
    };

    //log and send a message to the new connection
    console.log('New connection from %s', request.socket.remoteAddress);    
    message_list.push('From the server: I am the server');
    ws.send(JSON.stringify(message_list));
});

//start server
server.listen(PORT, () => {
    console.log(`> Server started on port ${PORT}`);
});
