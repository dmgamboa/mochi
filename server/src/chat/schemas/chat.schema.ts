import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { Message, MessageSchema } from './message.schema';

export type ChatDocument = HydratedDocument<Chat>;

@Schema()
export class Chat {
  @Prop({
    type: [String],
    required: true,
  })
  participants: string[];

  @Prop({
    type: [MessageSchema],
    required: true,
  })
  messages: Types.Array<Message>;
}

export const ChatSchema = SchemaFactory.createForClass(Chat);
