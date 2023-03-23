import { Document } from "mongoose";
import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";

@Schema()
export class FriendRequest extends Document {
  @Prop({ required: true })
  uid: string;

  @Prop({ required: true })
  date: Date;
}

export const FriendRequestSchema = SchemaFactory.createForClass(FriendRequest);