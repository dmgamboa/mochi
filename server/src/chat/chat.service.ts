import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Chat, ChatDocument } from './schemas/chat.schema';
import { CreateChatDto } from './dto/create-chat.dto';
import { MessageType } from 'src/enums/enums.messageType';
import { UsersService } from 'src/users/users.service';


// This is the service that will be used to interact with the database invloving the Chat model
@Injectable()
export class ChatService {
  private readonly usersService: UsersService;

  constructor(
    @InjectModel(Chat.name) private readonly chatModel: Model<ChatDocument>,
    usersService: UsersService,
  ) {
    this.usersService = usersService;
  }

  //CRUD operations
  //Create a chat
  async create(createChatDto: CreateChatDto): Promise<Chat> {
    const createdChat = await this.chatModel.create(createChatDto).catch(err => {
      return err.message;
    });
    return createdChat;
  }

  //Read
  //Get all user's chats by user id
  async findAll(userId: string): Promise<Chat[]> {
    const chats = await this.chatModel.find({participants: {$in: [userId]}}).exec();

    if (!chats) {
      return null;
    } else {
      return chats;
    }
  }

  //Find one chat by chat id
  async findOne(chatId: string, userId: string): Promise<Chat> {
    const chat = await this.chatModel.findOne({
      _id: chatId,
      participants: {$in: [userId]}}
    ).exec();

    if (!chat) {
      return null;
    } else {
      return chat;
    }
  }

  //Check if a chat exists
  async checkChatExists(participants: string[]): Promise<Chat> {
    const chat = await this.chatModel.findOne({participants: participants}).exec();

    if (!chat) {
      return null;
    } else {
      return chat;
    }
  }

  //Find one chat by chat id with pagination
  // async findOne(chatId: string, page): Promise<Chat> {
  //   const chat = await this.chatModel.findOne(
  //     {_id: chatId},
  //     {messages: {$slice: ['$messages', 10]}}
  //   ).exec();

  //   if (!chat) {
  //     return null;
  //   } else {
  //     return chat;
  //   }
  // }

  // //Find the most recent message in a chat
  // async findLastMessage(chatId: string): Promise<any> {
  //   const chat = await this.chatModel.findOne(
  //     {chat_id: chatId},
  //     {messages: {$slice: -1}}
  //   ).exec();

  //   if (!chat) {
  //     return null;
  //   } else {
  //     return chat;
  //   }
  // }

  //Update
  //Send a message to a chat
  async send(userId: string, chatId: string, message: string, type: MessageType): Promise<Chat> {
    const chat = await this.chatModel.findOneAndUpdate(
      {chat_id: chatId},
      {$push: {messages: {user_id: userId, message: message, type: type, date: new Date(Date.now())}}},
      {new: true}
    ).exec().catch(err => {
      return err.message;
    });
    return chat;
  }

  //Add a new participant to a chat
  async addUser(userId: string, chatId: string): Promise<any> {
    const user = await this.usersService.findOne(userId);

    if (!user) {
      return "User not found";
    }
    
    const chat = await this.chatModel.findOneAndUpdate(
      {chat_id: chatId},
      {$push: {participants: userId}},
      {new: true}
    ).exec().catch(err => {
      return err.message;
    });
    return chat;
  }

  //Remove a participant from a chat
  async removeUser(userId: string, chatId: string): Promise<any> {
    const user = await this.usersService.findOne(userId);

    if (!user) {
      return "User not found";
    }

    const chat = await this.chatModel.findOneAndUpdate(
      {chat_id: chatId},
      {$pull: {participants: userId}},
      {new: true}
    ).exec().catch(err => {
      return err.message;
    });
    return chat;
  }

  //Delete
  async remove(id: string): Promise<Chat> {
    const deletedChat = await this.chatModel.findOneAndRemove({_id: id}).exec().catch(err => {
      return err.message;
    });
    return deletedChat;
  }
}
