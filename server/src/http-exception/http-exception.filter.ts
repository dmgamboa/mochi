import { ExceptionFilter, Catch, ArgumentsHost, HttpException } from '@nestjs/common';
import { Response } from 'express';

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
    catch(exception: any, host: ArgumentsHost) {
        const ctx = host.switchToHttp();
        const response = ctx.getResponse<Response>();
        const status = exception.getStatus();

        //Status codes and error messages
        switch(status) {
            case 400:
                response
                    .status(status)
                    .json({
                        statusCode: status,
                        reason: 'Validation Error',
                        message: exception.message,
                    });
            break;

            case 401:
                response
                    .status(status)
                    .json({
                        statusCode: status,
                        reason: 'Unauthorized',
                        message: exception.message,
                    });
            break;

            case 404:
                response
                    .status(status)
                    .json({
                        statusCode: status,
                        reason: 'Not Found',
                        message: exception.message,
                    });
            break;

            case 500:
                response
                    .status(status)
                    .json({
                        statusCode: status,
                        reason: 'Internal Server Error',
                        message: exception.message,
                    });
            break;

            default:
                response
                    .status(status)
                    .json({
                        statusCode: status,
                        message: exception.message,
                    });
            break;
        }
    }
}