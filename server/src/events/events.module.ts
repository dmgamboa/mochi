import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Event, EventSchema } from './schemas/event.schema';
import { EventsService } from './events.service';
import { EventsController } from './events.controller';
import { UsersModule } from 'src/users/users.module';
import { StorageService } from 'src/storage/storage.service';

@Module({
    imports: [
        MongooseModule.forFeature([{ name: Event.name, schema: EventSchema }]),
        UsersModule
    ],
    controllers: [EventsController],
    providers: [EventsService, StorageService],
    exports: [EventsService],
})
export class EventsModule {}
