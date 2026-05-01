variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "function_sha256sum" {
  description = "SHA256 checksum of the Lambda function"
  type        = string
}

variable "base_endpoint" {
  description = "Base endpoint for the API Gateway"
  type        = string
  default     = "http://localhost:4566"
}

variable "stage" {
  description = "Stage of the API Gateway"
  type        = string
  default     = "dev"
}