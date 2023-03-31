import { Document } from 'mongoose';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

@Schema()
export class EventHistory extends Document {
  //removed unique: true for event_id until events are created.
  @Prop({ required: true })
  event_id: string;

  @Prop({ required: true })
  event: string;

  @Prop({ required: true })
  date: Date;

  //TODO: Make this a required field once we have a default image?
  @Prop({ type: String })
  image: String;
}

export const EventHistorySchema = SchemaFactory.createForClass(EventHistory);
