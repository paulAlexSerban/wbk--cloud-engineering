# Tailing API Gateway Execution Logs in AWS

## Prerequisites

- AWS CLI installed and configured with appropriate permissions
- API Gateway execution logging enabled in CloudWatch

## Command to Tail Logs

Use the following command to continuously stream logs for API Gateway execution:

```sh
aws logs tail API-Gateway-Execution-Logs_hb94bcwd7f/dev --follow
```

### Explanation:

- `aws logs tail` - Streams log events from CloudWatch.
- `API-Gateway-Execution-Logs_hb94bcwd7f/dev` - Replace `hb94bcwd7f` with your API Gateway ID and `dev` with your stage name.
- `--follow` - Keeps the log stream open and continuously fetches new log events.

## Additional Options

- To limit the number of logs fetched initially:
  ```sh
  aws logs tail API-Gateway-Execution-Logs_hb94bcwd7f/dev --follow --max-items 100
  ```
- To filter logs for specific keywords:
  ```sh
  aws logs tail API-Gateway-Execution-Logs_hb94bcwd7f/dev --follow --query 'events[?contains(message, `ERROR`)]'
  ```

## Troubleshooting

- Ensure you have the necessary permissions to access CloudWatch logs:
  ```json
  {
    "Effect": "Allow",
    "Action": "logs:TailLogEvents",
    "Resource": "arn:aws:logs:region:account-id:log-group:API-Gateway-Execution-Logs_*"
  }
  ```
- If no logs appear, confirm that execution logging is enabled in API Gateway settings.

## References

- [AWS CLI logs tail Documentation](https://docs.aws.amazon.com/cli/latest/reference/logs/tail.html)
- [AWS API Gateway Execution Logging](https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html)
