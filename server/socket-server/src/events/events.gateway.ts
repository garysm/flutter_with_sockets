
import {
  WebSocketGateway,
  WebSocketServer,
  OnGatewayInit,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import WebSocket, { Server } from 'ws';

@WebSocketGateway(8080)
export class EventsGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  messageList: Array<string> = [];

  afterInit(server: any) {
    console.log('Initialized');
  }

  // TODO: Optimize this, try to emit list of messages to every client
  // instead of sending them individually
  handleConnection(client: WebSocket, ...args: any[]) {
    let connectionMessage = 'New Client Connected';
    console.log(connectionMessage);
    this.messageList.push(connectionMessage);
    this.server.clients.forEach(serverClient => {
      serverClient.send(JSON.stringify(this.messageList));
    })
    client.on('message', (message: string) => {
      console.log(`Client Message: ${message}`);
      this.messageList.push(message);
      this.server.clients.forEach(client => {
        client.send(JSON.stringify(this.messageList));
      });
    })
  }

  handleDisconnect(client: any) {
    console.log('Client Disconnected');
  }
}