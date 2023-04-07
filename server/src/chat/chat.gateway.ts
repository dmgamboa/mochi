import {
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Socket, Server } from 'socket.io';
import { StorageService } from '../storage/storage.service';
import { ChatService } from './chat.service';
import { HttpException } from '@nestjs/common';

@WebSocketGateway()
export class ChatGateway {
  @WebSocketServer()
  server: Server;
  
  constructor(
    private storageService: StorageService,
    private readonly chatService: ChatService,
  ) {}

  @SubscribeMessage('message')
  async handleMessage(client: Socket, message) {
    try {
      const content = message.type === 'image'
        ? await this.storageService.saveImage(message.content, message.extension, message.chat_id)
        : message.content;
      const data = {
        ...message,
        content: content,
        extension: message.extension || '',
      }
      this.server.to(message.chat_id).emit('message', JSON.stringify(data));
      const chat = await this.chatService.send(message.user_id, message.chat_id, content, message.type);
      if (!chat) {
        throw new HttpException("Chat not found", 404);
      }
    } catch (err) {
      throw new HttpException(err, 500)
    }
  }

  handleConnection(client) {
    this.server.emit('connection', client.id);
  }

  handleDisconnect(client) {
    this.server.emit('disconnection', `${client.id} disconnected`);
  }

  @SubscribeMessage('room')
  joinRoom(socket: Socket, chatId: string) {
    socket.join(chatId);
  } 
}
