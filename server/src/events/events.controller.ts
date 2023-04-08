import { Body, Controller, Delete, Post, Get, Put, Param, HttpException, Req, Query } from '@nestjs/common';
import { EventsService } from './events.service';
import { CreateEventDto } from './dto/create-event.dto';
import { Event } from './schemas/event.schema';
import { UsersController } from '../users/users.controller';
import { StorageService } from 'src/storage/storage.service';
import { UsersService } from 'src/users/users.service';
import { EventHistoryDto } from 'src/users/dto/event-history.dto';

@Controller('events')
export class EventsController {
    usersController: UsersController;
    storageService: StorageService;
    usersService: UsersService;
    constructor(private readonly eventsService: EventsService, usersController: UsersController, storageService: StorageService, usersService: UsersService) {
        this.usersController = usersController;
        this.storageService = storageService;
        this.usersService = usersService;
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

    const currentTime = new Date().getTime();

    const filteredFriendsEventsArr = friendsEventsArr.filter((event) => new Date(event.date).getTime() > currentTime);

    // Include below code if you need an array of event objects, otherwise friendsEventsArr is an array of eventHistory objects
    // return await Promise.all(
    // friendsEventsArr.map(async (event) => {
    //   return await this.eventsService.find({_id: event.event_id})
    // })
    // )
    return filteredFriendsEventsArr;
  } catch (err) {
    throw new HttpException(err, 500);
  }
}

@Get('/invited')
async findAllInvitedEvents(@Req() request: Request): Promise<any> {
  try {
    const user = await this.usersController.findOne(request['user'].uid);

    const friends = await Promise.all(
      user.friends.map(async (friend) => {
        const friendUser = await this.usersController.findOne(friend.uid);
        return {
          name: friendUser.name,
          events: friendUser.events
        };
      })
    );

    const friendsEventsArr = friends
      .map((friend) => friend.events)
      .flat()
      .filter((event) => {
        return new Date(event.date).getTime() > new Date().getTime();
      });
      console.log(friendsEventsArr);

      const eventsArr = await Promise.all(
        friendsEventsArr.map(async (event) => {
          const [result] = await this.eventsService.find({ _id: event.event_id });
          return result;
        })
      );
    console.log('eventsArr');

    console.log(eventsArr);


    const filteredEventsArr = eventsArr.filter((event) => {
        return event.attendees.some((attendee) => {
          return attendee.id === request['user'].uid;
        });
      });
    console.log('filteredEventsArr')
    console.log(filteredEventsArr);

    const filteredEventHistoryArr = filteredEventsArr.map((event) => {
        return {
          event_id: event['_id'].toString(),
          event: event.event,
          date: event.startTime,
          image: event.image,
        };
      });
      console.log('filteredEventHistoryArr')
        console.log(filteredEventHistoryArr);

    return filteredEventHistoryArr;
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

    @Put('declineInvite/:id')
    async decline(@Param('id') id: string, @Req() request: Request, @Body('uid') uid: String): Promise<Event> {
        try {
            const event = await this.eventsService.attendeeToDeclinee(id, uid);
            if (event.event == null) {
                throw new HttpException(event, 404);
            } else {
                return event;
            }
        } catch (err) {
            throw new HttpException(err, 404);
        }
    }



    @Put('/acceptInvite/:id')
    async update(@Param('id') id: string, @Req() request: Request, @Body('uid') uid: String): Promise<Event> {
    try {
      const user = await this.usersController.findOne(request['user'].uid);
      const event = await this.eventsService.attendeeToAcceptee(id, uid, user);
      console.log('event');

      console.log(event);

      if (event.event == null) {
        throw new HttpException(event, 404);
      } else {
        const userEventData = [
            {
                event_id: id,
                event: event.event,
                date: event.startTime,
                image: event.image,
            }
        ] as EventHistoryDto[];
        const userId = user['_id'].toString();
        await this.usersService.updateEventList(userId, userEventData);
        return event;
      }
    } catch (err) {
      throw new HttpException(err, 404);
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