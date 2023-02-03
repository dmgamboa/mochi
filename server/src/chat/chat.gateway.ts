import { MessageBody, SubscribeMessage, WebSocketGateway, WebSocketServer} from '@nestjs/websockets';

@WebSocketGateway()
export class ChatGateway {
    @WebSocketServer()
    server;

    @SubscribeMessage('message')
    handleMessage(@MessageBody() message: string): void {
        this.server.emit('message', message);
    }

    handleConnection(client) {
        this.server.emit('connection', `${client.id} connected`);
    }
    
    handleDisconnect(client) {
        this.server.emit('disconnection', `${client.id} disconnected`);
    }
}