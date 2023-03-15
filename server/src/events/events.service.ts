import { Model } from 'mongoose';
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Event, EventDocument } from './schemas/event.schema';
import { CreateEventDto } from './dto/create-event.dto';

@Injectable()
export class EventsService {
    constructor(@InjectModel(Event.name) private eventModel: Model<EventDocument>) {}

    //Create
    async create(createEventDto: CreateEventDto): Promise<Event> {
        const createdEvent = new this.eventModel(createEventDto);
        return createdEvent.save();
    }

    //Read
    //Get all docs (for testing purposes)
    async findAll(): Promise<Event[]> {
        return this.eventModel.find().exec();
    }

    //Get docs by custom query
    async find(query: Object): Promise<Event[]> {
        const event = await this.eventModel.find(query).exec();
        return [...event];
    }

    //Update
    async upsert(id: String, createEventDto: CreateEventDto): Promise<Event> {
        const event = await this.eventModel.findByIdAndUpdate(id, createEventDto, {overwrite: true, 
            upsert: true, 
            runValidators: true})
            .exec();
        return event;
    }

    //Delete
    async delete(query: Object): Promise<Event> {
        const event = await this.eventModel.findOneAndDelete(query).exec();
        return event;
    }
}