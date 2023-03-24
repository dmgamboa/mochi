import { Document } from "mongoose";
import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";

@Schema()
export class Friend extends Document {
  @Prop({required: true})
  uid: string;

  @Prop({ type: Date })
  last_message_date: Date;
}

export const FriendSchema = SchemaFactory.createForClass(Friend);