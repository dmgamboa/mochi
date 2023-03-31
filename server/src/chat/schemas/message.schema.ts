import { Document } from 'mongoose';
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { MessageType } from 'src/enums/enums.messageType';

@Schema()
export class Message extends Document {
  @Prop({ required: true })
  user_id: string;

  @Prop({ required: true })
  message: string;

  @Prop({
    enum: MessageType,
    required: true
  })
  type: string;

  @Prop()
  extension: string;

  @Prop({ required: true })
  date: Date;
}

export const MessageSchema = SchemaFactory.createForClass(Message);
