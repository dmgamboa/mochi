import { Controller, Get, Req, Post } from '@nestjs/common';
import { Request } from 'express';
import { app } from 'firebase-admin';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('/login')
  getLogin(@Req() request: Request): string {
    return 'Successfully logged in ' + request['user']?.email + '!';
  }

  @Get('/signup')
  getSignup(@Req() request: Request): string {
    return 'Successfully Signed up ' + request['user']?.email + '!';
  }

  //for testing purposes, will be removed/refactored later
  @Post('/profileCreation')
  getProfileCreation(@Req() request: Request): JSON {
    return { ...request['user'], ...request['body'] } as JSON;
  }
}
