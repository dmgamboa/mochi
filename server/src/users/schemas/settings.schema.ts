import { Document } from "mongoose";
import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";
import { Interval } from "../../enums/enums.notifInterval";
import { Preferences } from "src/enums/enums.eventPreferences";

@Schema()
export class Settings extends Document {
    @Prop({
        type: [String],
        enum: Interval,
        required: true,
    })
    friend_hot_notifications: string[];

    @Prop({
        type: [String],
        enum: Interval,
        required: true,
    })
    friend_cold_notifications: string[];

    @Prop({
        type: [String],
        enum: Preferences,
        required: true,
    })
    event_notifications: string[];

    @Prop({
        type: Boolean,
        required: true,
    })
    dark_mode: boolean;
}

export const SettingsSchema = SchemaFactory.createForClass(Settings);