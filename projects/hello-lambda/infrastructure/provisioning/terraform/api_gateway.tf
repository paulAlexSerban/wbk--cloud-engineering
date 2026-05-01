resource "aws_api_gateway_rest_api" "hello-lambda_api" {
  name        = var.function_name
  description = "API Gateway for ${var.function_name}"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.hello-lambda_api.id
  parent_id   = aws_api_gateway_rest_api.hello-lambda_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.hello-lambda_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.hello-lambda_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello-lambda_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "hello-lambda_deployment" {
  rest_api_id = aws_api_gateway_rest_api.hello-lambda_api.id

  depends_on = [
    aws_api_gateway_method.proxy_method,
    aws_api_gateway_integration.lambda_integration
  ]
}

resource "aws_api_gateway_stage" "hello-lambda_stage" {
  stage_name    = var.stage
  rest_api_id   = aws_api_gateway_rest_api.hello-lambda_api.id
  deployment_id = aws_api_gateway_deployment.hello-lambda_deployment.id
}

output "api_gateway_invoke_url" {
  value = "http://localhost:4566/restapis/${aws_api_gateway_rest_api.hello-lambda_api.id}/${aws_api_gateway_stage.hello-lambda_stage.stage_name}/_user_request_/${var.function_name}"
}