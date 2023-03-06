import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreateUserDto } from './dto/create-user.dto';
import { User, UserDocument } from './schemas/user.schema';

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
    const user = await this.userModel.findOne({_id: id}).exec();

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

  //Update
  //Upsert - Add new document if id is not found, otherwise update the document with matching id
  async upsert(id: string, updateUserDto: CreateUserDto): Promise<User> {
    const user = await this.userModel.findByIdAndUpdate(id, updateUserDto, {overwrite: true, upsert: true}).exec();
    return user;
  }

  //Update - updates existing document with matching id
  async update(id: String, updateUserDto: CreateUserDto): Promise<User> {
    const user = await this.userModel.findByIdAndUpdate(id, updateUserDto, {overwrite: false, upsert: false}).exec()
    .catch(err => {
      return err.message;
    });
    return user;
  }

  //Delete
  async remove(id: string): Promise<User> {
    const deletedUser = await this.userModel.findByIdAndRemove({_id: id}).exec().catch(err => {
      return err.message;
    });
    return deletedUser;
  }
}
