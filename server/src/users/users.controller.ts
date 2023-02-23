import { Body, Controller, Delete, Get, Param, Post, Put } from '@nestjs/common';
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
            this.usersService.create(createUserDto);
        } catch (error) {
            console.log(error);
        }
    }

    //Read
    @Get()
    async findAll(): Promise<User[]> {
        try {
            return this.usersService.findAll();
        } catch (error) {
            console.log(error);
        }     
    }

    @Get('/findOne/:id')
    async findOne(@Param('id') id: string): Promise<User> {
        try {
            return this.usersService.findOne(id);
        } catch (error) {
            console.log(error);
        }
    }

    @Get('/find')
    async find(@Body() query: String): Promise<User[]> {
        try {
            return this.usersService.find(query);
        } catch (error) {
            console.log(error);
        }      
    }

    //Update
    @Put('/upsert/:id')
    async upsert(@Param('id') id: string, @Body() updateUserDto: CreateUserDto): Promise<User> {
        try {
            return this.usersService.upsert(id, updateUserDto);
        } catch (error) {
            console.log(error);
        }        
    }

    @Put('/update/:id')
    async update(@Param('id') id: string, @Body() updateUserDto: CreateUserDto): Promise<User> {
        try {
            return this.usersService.update(id, updateUserDto);
        } catch (error) {
            console.log(error);
        }      
    }

    //Delete
    @Delete('/delete/:id')
    async remove(@Param('id') id: string): Promise<User> {
        try {
            return this.usersService.remove(id);
        } catch (error) {
            console.log(error);
        }        
    }
}