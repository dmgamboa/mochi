import { Types } from 'mongoose';
import { Friend } from '../schemas/friend.schema';
import { EventHistory } from '../schemas/eventHistory.schema';
import { Settings } from '../schemas/settings.schema';
import { FriendRequest } from '../schemas/friendRequest.schema';

export class CreateUserDto {
  readonly name: string;
  readonly email: string;
  readonly uid: string;
  readonly profile_picture: string;
  readonly display_message: string;
  readonly friends: Types.Array<Friend>;
  readonly tags: string[];
  readonly events: Types.Array<EventHistory>;
  readonly social_medias: string[];
  readonly settings: Settings;
  readonly requests_in: Types.Array<FriendRequest>;
  readonly requests_out: Types.Array<FriendRequest>;
}
