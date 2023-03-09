import { Controller, Get, Req, Post, Inject } from '@nestjs/common';
import { Request } from 'express';
import { AppService } from './app.service';
import { CreateUserDto } from './users/dto/create-user.dto';
import { UsersService } from './users/users.service';
import { AnyKeys, AnyObject } from 'mongoose';
import { User } from './users/schemas/user.schema';
import { Interval } from './enums/enums.notifInterval';
import { Preferences } from './enums/enums.eventPreferences';

type BaseDoc<T> = AnyKeys<T> & AnyObject;

@Controller()
export class AppController {
  private readonly usersService: UsersService;
  constructor(
    // @Inject(UsersService)
    usersService: UsersService,
    private readonly appService: AppService,
  ) {
    this.usersService = usersService;
  }

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('/login')
  getLogin(@Req() request: Request): string {
    return 'Successfully logged in ' + request['user']?.email + '!';
  }

  @Get('/signup')
  async getSignup(@Req() request: Request): Promise<string> {
    // const emptyFriends = Array<Friend>();
    // const emptyEvents = Array<Event>();
    try {
      const newUser: BaseDoc<User> = {
        name: request['user']?.email,
        email: request['user']?.email,
        uid: request['user']?.uid,
        profile_picture: ' ',
        display_message: ' ',
        friends: null,
        tags: [],
        events: null,
        social_medias: [],
        settings: {
          friend_hot_notifications: [Interval.OFF],
          friend_cold_notifications: [Interval.OFF],
          event_notifications: [Preferences.OFF],
          dark_mode: false,
        },
      };
      await this.usersService.create(newUser as CreateUserDto);
      return 'Successfully Signed up ' + request['user']?.email + '!';
    } catch (error) {
      console.log(error);
      return 'Failed to create user.';
    }
  }

  @Post('/eventCreation')
  getEventCreation(@Req() request: Request): string {
    return JSON.stringify(request['body']);
  }


  //for testing purposes, will be removed/refactored later
  @Post('/profileCreation')
  async getProfileCreation(@Req() request: Request): Promise<any> {
    try {
      var users: User[] = await this.usersService.find({
        email: request['user']?.email,
      });

      if (users.length == 0) {
        return 'User not found';
      }

      var doc_id = users[0]['_id'];

      const newUser: BaseDoc<User> = {
        name: request['body']?.displayName,
        email: request['user']?.email,
        uid: request['user']?.uid,
        profile_picture: request['body']?.profileImage,
        display_message: request['body']?.displayMessage,
        friends: null,
        tags: request['body']?.interests,
        events: null,
        social_medias: [],
        settings: {
          friend_hot_notifications: [Interval.OFF],
          friend_cold_notifications: [Interval.OFF],
          event_notifications: [Preferences.OFF],
          dark_mode: false,
        },
      };

      await this.usersService.upsert(doc_id, newUser as CreateUserDto);
      return (
        'Successfully created profile for ' + request['body']?.displayName + '!'
      );
    } catch (error) {
      console.log(error);
      return 'Failed to create user.';
    }
  }
}
