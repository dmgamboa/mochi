import { Body, Controller, Delete, Post, Get, Put, Param, HttpException } from '@nestjs/common';
import { EventsService } from './events.service';
import { CreateEventDto } from './dto/create-event.dto';
import { Event } from './schemas/event.schema';

@Controller('events')
export class EventsController {
    constructor(private readonly eventsService: EventsService) {}

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

    //Read
    @Get('/findAll')
    async findAll(): Promise<Event[]> {
        return this.eventsService.findAll();
    }

    @Post('/find')
    async find(@Body() query): Promise<Event[]> {
        try {
            const events = await this.eventsService.find(query.body);

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