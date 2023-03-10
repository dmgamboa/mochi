export class CreateEventDto {
  readonly uid: string;
  readonly event: string;
  readonly startTime: Date;
  readonly endTime: Date;
  readonly date: Date;
  readonly location: string;
  readonly details: string;
  readonly attendees: string[];
  readonly tags: string[];
  readonly posts: string[];
}