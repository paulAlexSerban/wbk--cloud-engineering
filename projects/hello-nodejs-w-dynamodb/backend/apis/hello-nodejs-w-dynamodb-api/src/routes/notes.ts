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

router.get("/", async (req: Request, res: Response) => {
  const params: AWS.DynamoDB.DocumentClient.ScanInput = {
    TableName: TABLE_NAME,
  };

  try {
    const data = await docClient.scan(params).promise();
    res.json(data);
  } catch (err) {
    res.json(err);
  }
});

/**
 * Example w. SCAN
 */
// router.get("/:note_id", async (req: Request, res: Response) => {
//   const note_id = req.params.note_id;

//   const params = {
//     TableName: TABLE_NAME,
//     FilterExpression: "note_id = :note_id",
//     ExpressionAttributeValues: {
//       ":note_id": note_id,
//     },
//   };

//   try {
//     const data = await docClient.scan(params).promise();
//     res.json(data);
//   } catch (err) {
//     res.json(err);
//   }
// });

router.get("/:note_id", async (req: Request, res: Response) => {
  const { note_id } = req.params;

  const params: AWS.DynamoDB.DocumentClient.QueryInput = {
    TableName: TABLE_NAME,
    IndexName: "note_id-index",
    KeyConditionExpression: "note_id = :note_id",
    ExpressionAttributeValues: {
      ":note_id": note_id,
    },
    Limit: 1,
  };

  try {
    const data = await docClient.query(params).promise();
    res.json(data);
  } catch (err) {
    res.json(err);
  }
});

router.post("/", async (req: Request, res: Response) => {
  const { user_id, title, cat, content } = req.body;

  const timestamp = moment().unix();
  const note_id = uuid();

  const item_data = {
    note_id,
    user_id,
    title,
    cat,
    content,
    timestamp,
  };

  const params: AWS.DynamoDB.DocumentClient.PutItemInput = {
    TableName: TABLE_NAME,
    Item: item_data,
  };

  try {
    await docClient.put(params).promise();

    const response = {
      message: "Note created successfully",
      note_id,
    };
    res.json(response);
  } catch (err) {
    res.json(err);
  }
});

router.patch("/:note_id", async (req: Request, res: Response) => {
  const note_id = req.params.note_id;
  const { title, cat, content } = req.body;

  // First, retrieve the item using the note_id
  const getParams: AWS.DynamoDB.DocumentClient.QueryInput = {
    TableName: TABLE_NAME,
    IndexName: "note_id-index",
    KeyConditionExpression: "note_id = :note_id",
    ExpressionAttributeValues: {
      ":note_id": note_id,
    },
  };

  try {
    const getData = await docClient.query(getParams).promise();
    if (getData?.Items?.length === 0) {
      return res.status(404).json({ message: "Note not found" });
    }

    const item = getData?.Items?.[0];
    if (!item) {
      return res.status(404).json({ message: "Note not found" });
    }
    const { user_id, timestamp } = item;

    type ReqBody = "title" | "cat" | "content";

    type ExpressionAttribute = {
      [key: string]: string;
    };

    const expressionAttributeNamesPayload: ExpressionAttribute = {};
    const expressionAttributeValuesPayload: ExpressionAttribute = {};

    const attributesMapper: {
      [key in "title" | "cat" | "content"]: () => void;
    } = {
      title: () => {
        expressionAttributeNamesPayload["#title"] = "title";
        expressionAttributeValuesPayload[":title"] = title;
      },
      cat: () => {
        expressionAttributeNamesPayload["#cat"] = "cat";
        expressionAttributeValuesPayload[":cat"] = cat;
      },
      content: () => {
        expressionAttributeNamesPayload["#content"] = "content";
        expressionAttributeValuesPayload[":content"] = content;
      },
    };

    const attributes = Object.keys(req.body);
    attributes.forEach((attribute) => {
      if (attributesMapper[attribute as ReqBody]) {
        attributesMapper[attribute as ReqBody]();
      }
    });

    const getUpdateExpression = (payload: ExpressionAttribute) => {
      return Object.keys(payload)
        .map((key) => `${key} = :${payload[key]}`)
        .join(", ");
    };

    const updateExpression = getUpdateExpression(
      expressionAttributeNamesPayload
    );

    console.log({
      expressionAttributeNamesPayload,
      expressionAttributeValuesPayload,
      updateExpression,
    });

    const updateParams: AWS.DynamoDB.DocumentClient.UpdateItemInput = {
      TableName: TABLE_NAME,
      Key: {
        user_id,
        timestamp,
      },
      UpdateExpression: `SET ${updateExpression}`,
      ExpressionAttributeNames: expressionAttributeNamesPayload,
      ExpressionAttributeValues: expressionAttributeValuesPayload,
      ReturnValues: "UPDATED_NEW",
    };

    const updateData = await docClient.update(updateParams).promise();
    res.json({ user_id, timestamp, updateData });
  } catch (err) {
    res.status(500).json(err);
  }
});

router.delete("/:timestamp", async (req: Request, res: Response) => {
  const timestamp = parseInt(req.params.timestamp);
  const { user_id } = req.query;

  if (!user_id) {
    return res.status(400).json({ message: "Missing user_id" });
  }

  const params: AWS.DynamoDB.DocumentClient.DeleteItemInput = {
    TableName: TABLE_NAME,
    Key: {
      user_id,
      timestamp,
    },
  };

  try {
    await docClient.delete(params).promise();
    res.json({ message: "Note deleted successfully" });
  } catch (err) {
    res.json(err);
  }
});

export default router;
