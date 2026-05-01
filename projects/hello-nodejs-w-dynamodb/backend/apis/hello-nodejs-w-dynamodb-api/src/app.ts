import express, { Express, Request, Response, NextFunction } from 'express';
import cookieParser from 'cookie-parser';
import logger from 'morgan';
import routes from './routes';

const app: Express = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

app.use('/api', routes);

interface CustomError extends Error {
    statusCode?: number;
    value?: string;
    errors?: Record<string, { message: string }>;
    code?: number;
}

const errorHandler = (err: CustomError, req: Request, res: Response, next: NextFunction) => {
    console.log(err); // Enhanced logging
    res.json(err);
};

app.use(errorHandler);

export default app;
