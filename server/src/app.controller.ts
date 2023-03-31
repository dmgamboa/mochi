import { Controller, Get, Req, Post, Inject, HttpException } from '@nestjs/common';
import { Request } from 'express';
import { AppService } from './app.service';
import { CreateUserDto } from './users/dto/create-user.dto';
import { UsersService } from './users/users.service';
import { EventsService } from './events/events.service';
import { AnyKeys, AnyObject } from 'mongoose';
import { User } from './users/schemas/user.schema';
import { Interval } from './enums/enums.notifInterval';
import { Preferences } from './enums/enums.eventPreferences';
import { CreateEventDto } from './events/dto/create-event.dto';
import { EventHistoryDto } from './users/dto/event-history.dto';
import { UsersController } from './users/users.controller';

type BaseDoc<T> = AnyKeys<T> & AnyObject;

@Controller()
export class AppController {
  private readonly usersService: UsersService;
  private readonly eventsService: EventsService;
  private readonly usersController: UsersController;
  constructor(
    // @Inject(UsersService)
    eventsService: EventsService,
    usersService: UsersService,
    usersController: UsersController,
    private readonly appService: AppService,
  ) {
    this.usersService = usersService;
    this.eventsService = eventsService;
    this.usersController = usersController;
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
  async getEventCreation(@Req() request: Request): Promise<any> {
    // return JSON.stringify(request['body']);
    try {
      var users: User[] = await this.usersService.find({
        email: request['user']?.email,
      });

      if (users.length == 0) {
        return 'User not found';
      }

      var doc_id = users[0]['_id'];

    const newEvent: BaseDoc<Event> = {
      uid :  request['user']?.uid,
      event : request['body']?.title,
      startTime : request['body']?.startTime,
      endTime : request['body']?.endTime,
      startDate : request['body']?.startDate,
      endDate : request['body']?.endDate,
      location : request['body']?.location,
      details : request['body']?.details,
      image : request['body']?.image,
      attendees : request['body']?.attendees,
      tags : request['body']?.tags,
      posts : request['body']?.posts,
    }

    var createdEvent : any = await this.eventsService.create(newEvent as CreateEventDto);
    console.log(createdEvent);
    var eventId = createdEvent?._id.toString();
    console.log(eventId);

    var userEventData = 
    [{
      event_id: eventId,
      event: createdEvent.event,
      date: createdEvent.startTime,
      image: createdEvent.image,
    }] as EventHistoryDto[];
    console.log(userEventData);
    
    var test2 = await this.usersService.updateEventList(doc_id, userEventData);
    console.log(test2);
    return 'Successfully created event for ' + request['body']?.title + '!';
  }
    catch (error) {
    console.log(error);
    return 'Failed to create event.';
  }
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
        friends: [],
        tags: request['body']?.interests,
        events: [],
        social_medias: [],
        settings: {
          friend_hot_notifications: [Interval.OFF],
          friend_cold_notifications: [Interval.OFF],
          event_notifications: [Preferences.OFF],
          dark_mode: false,
        },
        requests_in: [],
        requests_out: [],
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

  @Post('/sendFriendRequest')
  async sendFriendRequest(@Req() request: Request): Promise<any> {
    try {
      await this.usersService.updateRequestsOut(request['user']?.uid, request['body']?.uid);
      await this.usersService.updateRequestsIn(request['body']?.uid, request['user']?.uid);
      return 'Successfully sent friend request!';
    }
    catch (error) {
      console.log(error);
      return 'Failed to send friend request.';
    }
  }

  @Post('/handleFriendRequest')
  async handleFriendRequest(@Req() request: Request): Promise<any> {
    try {
      if (request['body']?.accept == true) {
        await this.usersService.updateFriendsList(request['user']?.uid, request['body']?.uid);
        await this.usersService.updateFriendsList(request['body']?.uid, request['user']?.uid);
      }
      const { user_in } = await this.usersService.deleteRequests(request['user']?.uid, request['body']?.uid);

      const payload = await Promise.all(
        user_in.requests_in.map(async (requestIn) => {
            const user = await this.usersController.findOne(requestIn.uid);
            return {
                uid: requestIn.uid,
                date: requestIn.date,
                name: user.name,
                profile_picture: user.profile_picture,
            };
        })
      );

      console.log(payload)

      return payload

    } catch (err) {
      console.log(err);
      throw new HttpException(err, 500);
    }
  }

  @Post('/cancelFriendRequest')
  async cancelFriendRequest(@Req() request: Request): Promise<any> {
    try {
      const { user_out } = await this.usersService.deleteRequests(request['body']?.uid, request['user']?.uid);

      const payload = await Promise.all(
        user_out.requests_out.map(async (requestOut) => {
            const user = await this.usersController.findOne(requestOut.uid);
            return {
                uid: requestOut.uid,
                date: requestOut.date,
                name: user.name,
                profile_picture: user.profile_picture,
            };
        })
      );
      
      return payload

    } catch (err) {
      console.log(err);
      throw new HttpException(err, 500);
    }
  }
}
