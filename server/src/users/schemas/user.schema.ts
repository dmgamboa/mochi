import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { SocialMedia } from '../../enums/enums.socialMedia';
import { Tag } from '../../enums/enums.tag';
import { Friend, FriendSchema } from './friend.schema';
import { EventHistory, EventHistorySchema } from './eventHistory.schema';
import { Settings, SettingsSchema } from './settings.schema';
import { FriendRequest, FriendRequestSchema } from './friendRequest.schema';

export type UserDocument = HydratedDocument<User>;

@Schema()
export class User {
  @Prop({ required: true })
  name: string;

  @Prop({ required: true, unique: true })
  email: string;

  @Prop({ required: true })
  uid: string;

  @Prop({ required: true })
  profile_picture: string;

  @Prop({ required: true })
  display_message: string;

  @Prop({ type: [FriendSchema] })
  friends: Types.Array<Friend>;

  @Prop({
    type: [String],
    enum: Tag,
    required: true,
  })
  tags: string[];

  @Prop({ type: [EventHistorySchema] })
  events: Types.Array<EventHistory>;

  @Prop({
    type: [String],
    enum: SocialMedia,
    required: true,
  })
  social_medias: string[];

  @Prop({
    type: SettingsSchema,
    required: true,
  })
  settings: Settings;

  @Prop({ type: [FriendRequestSchema] })
  requests_in: Types.Array<FriendRequest>;

  @Prop({ type: [FriendRequestSchema] })
  requests_out: Types.Array<FriendRequest>;
}

export const UserSchema = SchemaFactory.createForClass(User);
