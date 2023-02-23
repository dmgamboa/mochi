import { Document } from "mongoose";
import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";

@Schema()
export class EventHistory extends Document {
    @Prop({required: true, unique: true})
    event_id: string;

    @Prop({required: true})
    event: string;

    @Prop({required: true})
    date: Date;
}

export const EventHistorySchema = SchemaFactory.createForClass(EventHistory);