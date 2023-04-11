import { Injectable} from '@nestjs/common';
import { Bucket } from '@google-cloud/storage';
import * as firebase from 'firebase-admin';
require('dotenv').config();

@Injectable()
export class StorageService {
  private bucket: Bucket;

  constructor() {
    this.bucket = firebase.storage().bucket();
  }

  async saveImage(base64File: string, extension: string, chatId: string): Promise<string> {
    const buffer = Buffer.from(base64File, 'base64');
    const filePath = `${chatId}/${Date.now().toString()}.${extension}`;
    const file = this.bucket.file(filePath);

    await file.save(buffer);
    await file.makePublic();

    return `https://storage.googleapis.com/${this.bucket.name}/${filePath}`;
  }

  async saveProfileImage(base64File: string, extension: string): Promise<string> {
    const buffer = Buffer.from(base64File, 'base64');
    const filePath = `profileImages/${Date.now().toString()}.${extension}`;
    const file = this.bucket.file(filePath);

    await file.save(buffer);
    await file.makePublic();

    return `https://storage.googleapis.com/${this.bucket.name}/${filePath}`;
  }

  async saveEventImage(base64File: string, extension: string): Promise<string> {
    const buffer = Buffer.from(base64File, 'base64');
    const filePath = `eventImages/${Date.now().toString()}.${extension}`;
    const file = this.bucket.file(filePath);

    await file.save(buffer);
    await file.makePublic();

    return `https://storage.googleapis.com/${this.bucket.name}/${filePath}`;
  }
}