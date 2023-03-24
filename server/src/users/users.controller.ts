import { Body, Controller, Delete, Get, Param, Post, Put, HttpException, Query, Req } from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { User } from './schemas/user.schema';
import { UserSearchDto } from './dto/userSearch.dto';
import { Request } from 'express';
import { FriendStatus } from 'src/enums/enums.friendStatus';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) { }

  //Create
  @Post()
  async create(@Body() createUserDto: CreateUserDto) {
    try {
      const user = await this.usersService.create(createUserDto);

      if (user.name == null) {
        throw new HttpException(user, 400);
      } else {
        return user;
      }
    } catch (err) {
      throw new HttpException(err, 400);
    }
  }

  //Read
  @Get()
  async findAll(): Promise<User[]> {
    try {
      const users = await this.usersService.findAll();

      if (users.length == 0) {
        throw new HttpException("Users not found", 404);
      } else {
        return users;
      }
    } catch {
      throw new HttpException("Users not found", 404);
    }
  }

  @Get('/findOne/:id')
  async findOne(@Param('uid') id: string): Promise<User> {
    try {
      const users = await this.usersService.findOne(id);

      if (users == null) {
        throw new HttpException("User not found", 404);
      } else {
        return users;
      }
    } catch {
      throw new HttpException("User not found", 404);
    }
  }

  @Get('/find')
  async find(@Query() query): Promise<User[]> {
    try {
      const users = await this.usersService.find(query);

      if (users.length == 0) {
        throw new HttpException(users, 404);
      } else {
        return users;
      }
    } catch (err) {
      throw new HttpException(err, 404);
    }
  }

  @Post('/find')
  async findByName(@Req() request: Request): Promise<UserSearchDto[]> {
    try {
      const users = await this.usersService.findByName(request['body']?.query);
      const userSearchDtos: UserSearchDto[] = [];

      if (!users) {
        return [];
      } else {
        const uid = request['user']?.uid;
        users.forEach((user) => {
          let status;
          if (user.friends?.some(item => item.uid === uid)) {
            status = FriendStatus.FRIEND;
          } else if (user.requests_in?.some(item => item.uid === uid) ||
            user.requests_out?.some(item => item.uid === uid)) {
            status = FriendStatus.PENDING;
          } else {
            status = FriendStatus.NOT_FRIEND;
          }
          userSearchDtos.push({
            user: {
              uid: user.uid,
              name: user.name,
              profile_picture: user.profile_picture,
              display_message: user.display_message,
            },
            status: status,
          })
        });
        return userSearchDtos;
      }
    } catch {
      throw new HttpException("DB Error", 500);
    }
  }

  @Get('/friends')
  async findFriends(@Req() request: Request): Promise<any> {
    try {
      const friends = await this.usersService.findFriends(request['user']?.uid);

      if (!friends) {
        throw new HttpException("User not found", 404);
      } else {
        const payload = await Promise.all(
          friends.map(async (friend) => {
            const user = await this.findOne(friend.uid);
            return {
              uid: friend.uid,
              last_message_date: friend.last_message_date,
              name: user.name,
              profile_picture: user.profile_picture,
              display_message: user.display_message,
            };
          })
        );
        return payload
      }
    } catch (err) {
      throw new HttpException(err, 404);
    }
  }

  @Get('/requests/in')
  async findRequestsIn(@Req() request: Request): Promise<any> {
    try {
      const requests = await this.usersService.findRequestsIn(request['user']?.uid);

      if (requests == null) {
        throw new HttpException("User not found", 404);
      } else {
        const payload = await Promise.all(
          requests.map(async (request) => {
            const user = await this.findOne(request.uid);
            return {
              user: {
                uid: user.uid,
                name: user.name,
                profile_picture: user.profile_picture,
                display_message: user.display_message,
              },
              date: request.date,
            };
          })
        );
        return payload
      }
    } catch (err) {
      throw new HttpException(err, 404);
    }
  }

  @Get('/requests/out')
  async findRequestsOut(@Req() request: Request): Promise<any> {
    try {
      const requests = await this.usersService.findRequestsOut(request['user']?.uid);

      if (requests == null) {
        throw new HttpException("User not found", 404);
      } else {
        const payload = await Promise.all(
          requests.map(async (request) => {
            const user = await this.findOne(request.uid);
            return {
              user: {
                uid: user.uid,
                name: user.name,
                profile_picture: user.profile_picture,
                display_message: user.display_message,
              },
              date: request.date,
            };
          })
        );
        return payload
      }
    } catch (err) {
      throw new HttpException(err, 404);
    }
  }

  //Update
  @Put('/upsert/:id')
  async upsert(@Param('id') id: string, @Body() updateUserDto: CreateUserDto): Promise<User> {
    return this.usersService.upsert(id, updateUserDto);
  }

  @Put('/update/:id')
  async update(@Param('id') id: string, @Body() updateUserDto: CreateUserDto): Promise<User> {
    try {
      const user = await this.usersService.update(id, updateUserDto);

      if (user.name == null) {
        throw new HttpException(user, 404);
      } else {
        return user;
      }
    } catch (err) {
      throw new HttpException(err, 404);
    }
  }

  //Delete
  @Delete('/delete/:id')
  async remove(@Param('id') id: string): Promise<User> {
    try {
      const user = await this.usersService.remove(id);

      if (user.name == null) {
        throw new HttpException(user, 404);
      } else {
        return user;
      }
    } catch (err) {
      throw new HttpException(err, 404);
    }
  }
}