import json

def lambda_handler(event: dict, context):
    print("Event:", json.dumps(event))
    try:
        # Extract specific attributes from the context object
        context_info = {
            "function_name": context.function_name,
            "memory_limit_in_mb": context.memory_limit_in_mb,
            "aws_request_id": context.aws_request_id
        }
        return {
            "statusCode": 200,
            "body": json.dumps({"event": event, "context": context_info})
        }
    except Exception as e:
        print("Error:", str(e))
        raise