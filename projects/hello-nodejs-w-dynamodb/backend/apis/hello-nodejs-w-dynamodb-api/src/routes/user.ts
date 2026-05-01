import moment from "moment";
import express, { Router, Request, Response, NextFunction } from "express";
import { v4 as uuid } from "uuid";
import _ from "underscore";
import AWS from "aws-sdk";
import dotenv from "dotenv";

dotenv.config();

const router: Router = express.Router();

const AWS_REGION = process.env.AWS_REGION;
const DYNAMO_ENDPOINT = process.env.DYNAMO_ENDPOINT;
const TABLE_NAME = process.env.TABLE_NAME;

if (!AWS_REGION || !DYNAMO_ENDPOINT || !TABLE_NAME) {
  throw new Error("Missing environment variables");
}

const docClient = new AWS.DynamoDB.DocumentClient({
  region: AWS_REGION,
  endpoint: DYNAMO_ENDPOINT,
});

router.get("/:user_id", async (req: Request, res: Response) => {
    const limit = req.query.limit ? parseInt(req.query.limit as string) : 10;
    const startTimeStamp = req.query.startTimeStamp
      ? parseInt(req.query.startTimeStamp as string)
      : 0;
    const user_id = req.params.user_id;
    
    const params: AWS.DynamoDB.DocumentClient.QueryInput = {
      TableName: TABLE_NAME,
      KeyConditionExpression: "user_id = :user_id",
      ExpressionAttributeValues: {
        ":user_id": user_id,
      },
      Limit: limit,
      ScanIndexForward: false,
    };
  
    if (startTimeStamp > 0) {
      params["ExclusiveStartKey"] = {
        user_id,
        timestamp: startTimeStamp,
      };
    }
  
    try {
      const data = await docClient.query(params).promise();
      res.json(data);
    } catch (err) {
      res.json(err);
    }
  });
  
  export default router;