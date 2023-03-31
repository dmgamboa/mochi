import { Types } from 'mongoose';
import { Attendee } from 'src/users/schemas/attendee.schema';

export class CreateEventDto {
  readonly uid: string;
  readonly event: string;
  readonly startTime: Date;
  readonly endTime: Date;
  readonly startDate: Date;
  readonly endDate: Date;
  readonly location: string;
  readonly details: string;
  readonly image: string;
  readonly attendees: Types.Array<Attendee>;
  readonly tags: string[];
  readonly posts: string[];
}