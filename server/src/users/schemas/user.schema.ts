import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';
import { SocialMedia } from '../../enums/enums.socialMedia';
import { Tag } from '../../enums/enums.tag';
import { Friend, FriendSchema } from './friend.schema';
import { EventHistory, EventHistorySchema } from './eventHistory.schema';

export type UserDocument = HydratedDocument<User>;

@Schema()
export class User {
    @Prop({required: true})
    name: string;

    @Prop({required: true, unique: true})
    email: string;

    @Prop({required: true})
    uid: string;

    @Prop({required: true})
    profile_picture: string;

    @Prop({
        type: [FriendSchema],
        //required: true,
    })
    friends: Types.Array<Friend>;

    @Prop({
        type: [String],
        enum: Tag,
        required: true,
    })
    tags: string[];

     @Prop({
        type: [EventHistorySchema],
        //required: true,
     })
    events: Types.Array<EventHistory>;

    @Prop({
        type: [String],
        enum: SocialMedia,
        required: true,
    })
    social_medias: string[];
}

export const UserSchema = SchemaFactory.createForClass(User);