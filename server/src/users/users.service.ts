import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreateUserDto } from './dto/create-user.dto';
import { EventHistoryDto } from './dto/event-history.dto';
import { User, UserDocument } from './schemas/user.schema';
import { Friend } from './schemas/friend.schema';
import { FriendRequest } from './schemas/friendRequest.schema';

// This is the service that will be used to interact with the database invloving the User model
@Injectable()
export class UsersService {
    constructor(
      @InjectModel(User.name) private readonly userModel: Model<UserDocument>
    ) {}

  //CRUD operations
  //Create
  async create(createUserDto: CreateUserDto): Promise<User> {
    const createdUser = await this.userModel.create(createUserDto).catch(err => {
    return err.message;
    });
    return createdUser;
  }

  //Read
  //Get all users
  async findAll(): Promise<User[]> {
    const users = await this.userModel.find().exec();
    return [...users];
  }

  //Find one user by id
  async findOne(id: string): Promise<User> {
    const user = await this.userModel.findOne({uid: id}).exec();

      if (user == null) {
        return null;
      } else {
        return user;
      }
  }

  //Find users by custom query. Query is a JSON object from request body
  async find(query: Object): Promise<User[]> {
    const users = await this.userModel.find(query).exec().catch(err => {
      return err.message;
    });
    return [...users];     
  }

  //Find users by name
  async findByName(name: string): Promise<User[]> {
    const users = await this.userModel.find({name: name}).exec().catch(err => {
      return err.message;
    });
    return users;
  }

  //Find user's friends list by id
  async findFriends(id: string): Promise<Friend[]> {
    const user = await this.userModel.findOne({uid: id}).exec();

    if (!user) {
      return null;
    } else if (!user.friends) {
      return [];
    } else {
      return user.friends;
    }
  }

  //Find user's incoming requests by id
  async findRequestsIn(id: string): Promise<FriendRequest[]> {
    const user = await this.userModel.findOne({uid: id}).exec();

    if (!user) {
      return null;
    } else if (!user.requests_in) {
      return [];
    } else {
      return user.requests_in;
    }
  }

  //Find user's outgoing requests by id
  async findRequestsOut(id: string): Promise<FriendRequest[]> {
    const user = await this.userModel.findOne({uid: id}).exec();

    if (!user) {
      return null;
    } else if (!user.requests_out) {
      return [];
    } else {
      return user.requests_out;
    }
  }

  //Update
  //Upsert - Add new document if id is not found, otherwise update the document with matching id
  async upsert(id: string, updateUserDto: CreateUserDto): Promise<User> {
    const user = await this.userModel.findByIdAndUpdate(id, updateUserDto, {overwrite: true, upsert: true}).exec();
    return user;
  }

  //Update - updates existing document with matching id
  async update(id: String, body: any): Promise<User> {
    const user = await this.userModel.findByIdAndUpdate(id, body, {overwrite: false, upsert: false}).exec()
    .catch(err => {
      return err.message;
    });
    return user;
  }

  //Update - updates existing document with matching id and adds event to events list
  async updateEventList(id: string, event: EventHistoryDto[]): Promise<User> {
    const user = await this.userModel.findByIdAndUpdate(id, {$push: {events: {$each: event}}}, {overwrite: false, upsert: false}).exec()
    .catch(err => {
      return err.message;
    });
    return user;
  }

  //Update - updates existing document with matching id and adds new request to incoming requests list
  async updateRequestsIn(id: String, friendId: String): Promise<User> {
    // Check for duplicate requests in outgoing requests list
    const user = await this.userModel.findOne({uid: id}).exec().catch(err => {
      return err.message;
    });

    if (!user.requests_out?.some(item => item.uid === friendId)) {
      const requestIn = {uid: friendId, date: new Date(Date.now())} as FriendRequest;
      await this.userModel.findOneAndUpdate(
        {uid: id},
        {$addToSet: {requests_in: requestIn}},
        {overwrite: false, upsert: false}
      ).exec().catch(err => {
        return err.message;
      });
    }

    return user;
  }

  //Update - updates existing document with matching id and adds new request to outgoing requests list
  async updateRequestsOut(id: String, friendId: String): Promise<User> {
    // Check for duplicate requests in incoming requests list
    const user = await this.userModel.findOne({uid: id}).exec().catch(err => {
      return err.message;
    });

    if (!user.requests_in?.some(item => item.uid === friendId)) {
      const requestOut = {uid: friendId, date: new Date(Date.now())} as FriendRequest;
      console.log(requestOut)
      await this.userModel.findOneAndUpdate(
        {uid: id},
        {$addToSet: {requests_out: requestOut}},
        {overwrite: false, upsert: false}
      ).exec().catch(err => {
        return err.message;
      });
    }

    return user;
  }

  //Update - updates existing document with matching id and adds new friend to friends list
  async updateFriendsList(id: String, friendId: String): Promise<User> {
    const friend = {uid: friendId, last_message_date: null} as Friend;
    const user = await this.userModel.findOneAndUpdate(
      {uid: id},
      {$addToSet: {friends: friend}},
      {overwrite: false, upsert: false}
    ).exec().catch(err => {
      return err.message;
    });
    return user;
  }

  //Update - updates existing document with matching id and adds new friend to friends list
  async deleteRequests(inId: String, outId: String): Promise<any> {
    const user_in = await this.userModel.findOneAndUpdate(
      {uid: inId},
      {$pull: {requests_in: {uid: outId}}},
      {new: true}
    ).exec().catch(err => {
      return err.message;
    });

    const user_out = await this.userModel.findOneAndUpdate(
      {uid: outId},
      {$pull: {requests_out: {uid: inId}}},
      {new: true}
    ).exec().catch(err => {
      return err.message;
    });

    return {user_in, user_out};
  }

  //Delete
  async remove(id: string): Promise<User> {
    const deletedUser = await this.userModel.findByIdAndRemove({_id: id}).exec().catch(err => {
      return err.message;
    });
    return deletedUser;
  }
}
