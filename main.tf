provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

variable "region" {
  default     = "us-east-1"
}

resource "aws_iam_role" "iam_hello_world_feravila" {
  name = "iam_hello_world_feravila_tf_n"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_function" "hello_world_feravila" {
  filename      = "handler.zip"
  function_name = "hello_world_feravila_tf_n"
  role          = aws_iam_role.iam_hello_world_feravila.arn
  handler       = "main"

  source_code_hash = filebase64sha256("handler.zip")

  runtime = "go1.x"

  environment {
    variables = {
      foo = "FernandoTF"
    }
  }
}

resource "aws_iam_policy" "lambda_cloudwatch_policy" {
  name        = "lambda_cloudwatch_policy"
  description = "Policy to allow Lambda function to write to CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.hello_world_feravila.function_name}:*"
      }
    ],
  })
}

resource "aws_iam_policy_attachment" "lambda_cloudwatch_attachment" {
  name       = "lambda_cloudwatch_attachment"
  roles      = [aws_iam_role.iam_hello_world_feravila.name]
  policy_arn = aws_iam_policy.lambda_cloudwatch_policy.arn
}
