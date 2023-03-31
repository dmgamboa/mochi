import {
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
  HttpException,
  Req
} from '@nestjs/common';
import { Request } from 'express';
import { AnyKeys, AnyObject } from 'mongoose';
import { ChatService } from './chat.service';
import { CreateChatDto } from './dto/create-chat.dto';
import { Chat } from './schemas/chat.schema';
import { UsersController } from 'src/users/users.controller';

type BaseDoc<T> = AnyKeys<T> & AnyObject;

@Controller('chats')
export class ChatController {
  private readonly usersController: UsersController;

  constructor(
    private readonly chatService: ChatService,
    usersController: UsersController,
  ) {
    this.usersController = usersController;
  }

  //Create
  @Post('/newChat')
  async create(@Req() request: Request): Promise<any> {
    try {
      const chat = await this.chatService.checkChatExists(request['body'].participants);
      
      if (chat) {
        return chat;
      }

      const newChat: BaseDoc<Chat> = {
        participants: request['body'].participants,
        messages: [{
          user_id: request['user'].uid,
          message: request['body'].message,
          type: request['body'].type,
          date: new Date(Date.now())
        }],
      }

      const createdChat = await this.chatService.create(newChat as CreateChatDto);

      if (!createdChat) {
        throw new HttpException(createdChat, 400);
      } else {
        const participants = await Promise.all(
          createdChat.participants.map(async (participant) => {
            const user = await this.usersController.findOne(participant);
            return {
              uid: participant,
              name: user.name,
              profile_picture: user.profile_picture,
              role: request['user'].uid == participant ? 'sender' : 'receiver',
            };
          })
        );

        return {
          chat: createdChat,
          participants: participants,
        }
      }
    } catch (err) {
      throw new HttpException(err, 500);
    }
  }

  //Read
  @Get()
  async findAll(@Req() request: Request): Promise<any> {
    try {
      const chats = await this.chatService.findAll(request['user'].uid);

      if (!chats) {
        throw new HttpException("Chats not found", 404);
      } else {
        const payload = await Promise.all(
          chats.map(async (chat) => {
            const participants = await Promise.all(
              chat.participants.map(async (participant) => {
                const user = await this.usersController.findOne(participant);
                return {
                  uid: participant,
                  name: user.name,
                  profile_picture: user.profile_picture,
                  role: request['user'].uid == participant ? 'sender' : 'receiver',
                };
              })
            );

            const last_message = chat.messages[chat.messages.length - 1];
            return {
              chat: chat,
              participants: participants,
              last_message: last_message,
            };
          })
        );
        return payload.filter((chat) => chat.last_message != null);
      }
    } catch (err) {
      throw new HttpException(err, 500);
    }
  }

  @Get('/:id')
  async findOne(@Param('id') id: string, @Req() request: Request): Promise<any> {
    try {
      const chat = await this.chatService.findOne(id, request['user'].uid);
      // const chat = await this.chatService.findOne(id, request['body'].messageIndex);

      if (!chat) {
        throw new HttpException("Chat not found", 404);
      } else {
        const participants = await Promise.all(
          chat.participants.map(async (participant) => {
            const user = await this.usersController.findOne(participant);
            return {
              uid: participant,
              name: user.name,
              profile_picture: user.profile_picture,
              role: request['user'].uid == participant ? 'sender' : 'receiver',
            };
          })
        );

        return {
          chat: chat,
          participants: participants,
        }
      }
    } catch (err) {
      throw new HttpException(err, 500);
    }
  }

  //Update
  @Put('/send')
  async send(@Req() request: Request): Promise<Chat> {
    try {
      const chat = await this.chatService.send(
        request['user']?.uid,
        request['body']?.chatId,
        request['body']?.message,
        request['body']?.type, 
      );

      if (!chat) {
        throw new HttpException("Chat not found", 404);
      } else {
        return chat;
      }
    } catch (err) {
      throw new HttpException(err, 500);
    }
  }

  @Put('/addUser')
  async addUser(@Req() request: Request): Promise<any> {
    try {
      const chat = await this.chatService.addUser(
        request['body']?.uid,
        request['body']?.chatId,
      );

      if (!chat) {
        throw new HttpException("Chat not found", 404);
      } else if (chat === 'User not found') {
        throw new HttpException("User not found", 404);
      } else {
        const participants = await Promise.all(
          chat.participants.map(async (participant) => {
            const user = await this.usersController.findOne(participant);
            return {
              uid: participant,
              name: user.name,
              profile_picture: user.profile_picture,
              role: request['user'].uid == participant ? 'sender' : 'receiver',
            };
          })
        );

        return {
          chat: chat,
          participants: participants,
        };
      }
    } catch (err) {
      throw new HttpException(err, 500);
    }
  }

  @Put('/removeUser')
  async removeUser(@Req() request: Request): Promise<Chat> {
    try {
      const chat = await this.chatService.removeUser(
        request['user']?.uid,
        request['body']?.chatId,
      );

      if (!chat) {
        throw new HttpException("Chat not found", 404);
      } else if (chat === 'User not found') {
        throw new HttpException("User not found", 404);
      } else {
        return chat;
      }
    } catch (err) {
      throw new HttpException(err, 500);
    }
  }

  //Delete
  @Delete('/delete/:id')
  async remove(@Param('id') id: string): Promise<Chat> {
    try {
      const chat = await this.chatService.remove(id);

      if (!chat) {
        throw new HttpException(chat, 404);
      } else {
        return chat;
      }
    } catch (err) {
      throw new HttpException(err, 404);
    }
  }
}