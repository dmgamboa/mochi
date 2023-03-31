import {
  ConnectedSocket,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Socket, Server } from 'socket.io';
import { StorageService } from '../storage/storage.service';

@WebSocketGateway()
export class ChatGateway {
  @WebSocketServer()
  server: Server;
  
  constructor(private storageService: StorageService) {}

  @SubscribeMessage('message')
  async handleMessage(@ConnectedSocket() client: Socket, message) {
    const content = message.extension 
      ? await this.storageService.saveImage(message.content, message.extension)
      : message.content;
    const data = {
      ...message,
      content: content,
      extension: message.extension || '',
      id: client.id
    }
    this.server.to(message.chatId).emit('message', JSON.stringify(data));
  }

  handleConnection(client) {
    this.server.emit('connection', client.id);
  }

  handleDisconnect(client) {
    this.server.emit('disconnection', `${client.id} disconnected`);
  }

  @SubscribeMessage('room')
  joinRoom(@ConnectedSocket() socket: Socket, chatId: string) {
    socket.join(chatId);
  }
}
