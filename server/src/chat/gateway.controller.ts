// import { Controller, Post, Body } from '@nestjs/common';
// import { WebSocketServer, WebSocketGateway, OnGatewayConnection } from '@nestjs/websockets';
// import { Server, Socket } from 'socket.io';
// import { ChatService } from './gateway.service';
// import { Message } from './gateway.model';

// @WebSocketGateway()
// @Controller('chat')
// export class GatewayController implements OnGatewayConnection {
//   @WebSocketServer()
//   server: Server;

//   constructor(private chatService: ChatService) {}

//   handleConnection(client: Socket) {
//     // Add logic for handling incoming connections from clients
//     this.server.emit('connection', client.id);
//     // console.log(`Client connected: ${client.id}`);
//   }

//   handleDisconnect(client) {
//     this.server.emit('disconnection', client.id);
//   }

//   @Post()
//   async sendMessage(@Body() message: Message) {
//     this.chatService.addMessage(message);
//     console.log(`Received message: ${message.text}`);
//     return message;
//   }
// }
