import { Document } from "mongoose";
import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";

@Schema()
export class Attendee extends Document {
  @Prop({required: true})
  id: string;

  @Prop({ required: true, type: String })
  name: string;

  @Prop({required: true})
  profile_picture: string;

  @Prop({type: String})
  display_message: string;

}

export const AttendeeSchema = SchemaFactory.createForClass(Attendee);