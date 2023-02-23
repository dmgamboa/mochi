import { Document } from "mongoose";
import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";

@Schema()
export class Friend extends Document {
    @Prop({required: true})
    uid: string;

    @Prop({required: true})
    name: string;

    @Prop({required: true})
    profile_picture: string;

    @Prop({
        type: Date,
        required: true,
    })
    last_message_date: Date;
}

export const FriendSchema = SchemaFactory.createForClass(Friend);