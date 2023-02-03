// import { WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
// import { Server } from 'socket.io';

// @WebSocketGateway()
// export class Gateway {
//   @WebSocketServer()
//   server : Server;

//   handleConnection(client) {
//     this.server.emit('connection', client.id);
//   }

//   handleDisconnect(client) {
//     this.server.emit('disconnection', client.id);
//   }
// }