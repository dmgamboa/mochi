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
        try {
            const createdUser = await this.userModel.create(createUserDto);
            return createdUser;
        } catch (error) {
            console.log(error);
        }      
    }

    //Read
    //Get all users
    async findAll(): Promise<User[]> {
        try {
            const users = await this.userModel.find().exec();
            return [...users];
        } catch (error) {
            console.log(error);
        }       
    }

    //Find one user by id
    async findOne(id: string): Promise<User> {
        try {
            return this.userModel.findOne({_id: id}).exec();
        } catch (error) {
            console.log(error);
        }       
    }

    //Find users by custom query. Query is a JSON object from request body
    async find(query: String): Promise<User[]> {
        try {
            const users = await this.userModel.find(query).exec();
            return [...users];
        } catch (error) {
            console.log(error);
        }       
    }

    //Update
    //Upsert - Add new document if id is not found, otherwise update the document with matching id
    async upsert(id: string, updateUserDto: CreateUserDto): Promise<User> {
        try {
            const user = await this.userModel.findByIdAndUpdate(id, updateUserDto, {overwrite: true, upsert: true}).exec();
            return user;
        } catch (error) {
            console.log(error);
        }       
    }

    //Update - updates existing document with matching id
    async update(id: String, updateUserDto: CreateUserDto): Promise<User> {
        try {
            const user = await this.userModel.findByIdAndUpdate(id, updateUserDto, {overwrite: false, upsert: false}).exec();
            return user;
        } catch (error) {
            console.log(error);
        }        
    }

    //Delete
    async remove(id: string): Promise<User> {
        try {
            const deletedUser = await this.userModel.findByIdAndRemove({_id: id}).exec();
            return deletedUser;
        } catch (error) {
            console.log(error);
        }        
    }
}