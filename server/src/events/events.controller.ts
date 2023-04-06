import { Body, Controller, Delete, Post, Get, Put, Param, HttpException, Req, Query } from '@nestjs/common';
import { EventsService } from './events.service';
import { CreateEventDto } from './dto/create-event.dto';
import { Event } from './schemas/event.schema';
import { UsersController } from '../users/users.controller';
import { StorageService } from 'src/storage/storage.service';

@Controller('events')
export class EventsController {
    usersController: UsersController;
    storageService: StorageService;
    constructor(private readonly eventsService: EventsService, usersController: UsersController, storageService: StorageService) {
        this.usersController = usersController;
        this.storageService = storageService;
    }

    //Create
    @Post('/create')
    async create(@Body() createEventDto: CreateEventDto): Promise<Event> {
        try {
            const event = await this.eventsService.create(createEventDto).catch(err => {
                throw new HttpException(err, 400);
            });
            return event;
        } catch (err) {
            throw new HttpException(err, 400);
        }     
    }

    @Get('/friends')
    async findAllFriendEvents(@Req() request: Request): Promise<any> {
        try {
            const user = await this.usersController.findOne(request['user'].uid);
            console.log(user);

            const friends = await Promise.all(
            user.friends.map(async (friend) => {
            const friendUser = await this.usersController.findOne(friend.uid);
            return {
            name: friendUser.name,
            eventHistroy: friendUser.events
            }
        })
    )

    const friendsEventsSet = new Set(friends.map((friend) => friend.eventHistroy).flat());
    const friendsEventsArr = Array.from(friendsEventsSet);

    // Include below code if you need an array of event objects, otherwise friendsEventsArr is an array of eventHistory objects
    // return await Promise.all(
    // friendsEventsArr.map(async (event) => {
    //   return await this.eventsService.find({_id: event.event_id})
    // })
    // )
    return friendsEventsArr;
  } catch (err) {
    throw new HttpException(err, 500);
  }
}

    //Read
    @Get('/findAll')
    async findAll(): Promise<Event[]> {
        return this.eventsService.findAll();
    }

    @Post('/find')
    async find(@Body() query): Promise<Event[]> {
        try {
            const events = await this.eventsService.find(query);

            if (events.length == 0) {
                throw new HttpException(events, 404);
            } else {
                return events;
            } 
        } catch (err) {
            throw new HttpException(err, 404);
        }      
    }

    //Update
    @Put('/upsert/:id')
    async upsert(@Param('id') id: String, @Body() createEventDto: CreateEventDto): Promise<Event> {
        try {
            const event = await this.eventsService.upsert(id, createEventDto).catch(err => {
                throw new HttpException(err, 400);
            });
            return event;
        } catch (err) {
            throw new HttpException(err, 400);
        }     
    }

    @Post('/saveEventImage')
    async saveEventImage(@Req() request: Request): Promise<any> {
    try {
        console.log(request['body']['image64'])
      const ImageURL = await this.storageService.saveEventImage(request['body']['image64'], request['body']['extension']);
      return ImageURL;
    } catch (err) {
      throw new HttpException(err, 404);
    }
  }

    //Delete
    @Delete('/delete')
    async delete(@Body() query): Promise<Event> {
        try {
            const event = await this.eventsService.delete(query.body);

            if (event.event == null) {
                throw new HttpException(event, 404);
            } else {
                return event;
            }
        } catch (err) {
            throw new HttpException(err, 404);
        }
    }
}