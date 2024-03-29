import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { Attendee, AttendeeSchema } from 'src/users/schemas/attendee.schema';
import { Tag } from '../../enums/enums.tag';

export type EventDocument = HydratedDocument<Event>;

@Schema()
export class Event {
    @Prop({required: true})
    uid: string;

    @Prop({required: true})
    event: string;

    @Prop({
        required: true,
        type: Date,
    })
    startTime: Date;

    @Prop({
        required: true,
        type: Date,
    })
    endTime: Date;

    @Prop({
        required: true,
        type: Date,
    })
    startDate: Date;

    @Prop({
        required: true,
        type: Date,
    })
    endDate: Date;

    @Prop({required: true})
    location: string;

    @Prop({required: true})
    details: string;

    @Prop({required: true})
    image: string;

    @Prop({
        type: [AttendeeSchema],
    })
    attendees: Types.Array<Attendee>;

    @Prop({
        type: [AttendeeSchema],
    })
    acceptees: Types.Array<Attendee>;

    @Prop({
        required: true,
        type: [String],
        enum: Tag,
    })
    tags: string[];

    @Prop({required: true})
    posts: string[];
}

export const EventSchema = SchemaFactory.createForClass(Event);