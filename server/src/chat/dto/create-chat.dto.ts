import { Types } from 'mongoose';
import { Message } from 'src/chat/schemas/message.schema';

export class CreateChatDto {
  readonly participants: string[];
  readonly messages: Types.Array<Message>;
}
