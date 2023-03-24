import { FriendStatus } from '../../enums/enums.friendStatus';

class User {
  uid: string;
  name: string;
  profile_picture: string;
  display_message: string;
}

export class UserSearchDto {
  user: User;
  status: FriendStatus;
}