import { Body, Controller, Delete, Get, Param, Post, Put, HttpException, Query } from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { User } from './schemas/user.schema';

@Controller('users')
export class UsersController {
    constructor(private readonly usersService: UsersService) {}

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
    async findOne(@Param('id') id: string): Promise<User> {
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

    //Update
    @Put('/upsert/:id')
    async upsert(@Param('id') id: string, @Body() updateUserDto: CreateUserDto): Promise<User> {
        return this.usersService.upsert(id, updateUserDto);           
    }

    @Put('/update/:id')
    async update(@Param('id') id: string, @Body() body: any): Promise<User> {
        try {
            const user = await this.usersService.update(id, body);

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