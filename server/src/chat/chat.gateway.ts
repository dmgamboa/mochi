import {
  MessageBody,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer
} from '@nestjs/websockets';
import { Socket, Server } from 'socket.io';
import { Logger } from '@nestjs/common';

@WebSocketGateway()
export class ChatGateway {
  @WebSocketServer()
  server: Server;
  
  private logger: Logger = new Logger('ChatGateway');

  @SubscribeMessage('message')
  handleMessage(client: Socket, message: { sender: string, message: string }) {
    this.server.emit('message', message);
  }

  handleConnection(client) {
    this.server.emit('connection', client.id);
  }

  handleDisconnect(client) {
    this.server.emit('disconnection', `${client.id} disconnected`);
  }
}
