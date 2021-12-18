resource "aws_iam_role" "lambda_role" {
  name = "iam_for_lambda"

  assume_role_policy = jsonencode({
    Version: "2012-10-17"
    Statement: [
      {
        Action: "sts:AssumeRole"
        Principal: {
          Service: "lambda.amazonaws.com"
        }
        Effect: "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy" "logs_policy" {
  name   = "lambda-logs"
  role   = aws_iam_role.lambda_role.name
  policy = jsonencode({
    Statement: [
      {
        Action: [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect: "Allow"
        Resource: "arn:aws:logs:*:*:*"
      },
      {
        Action: [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect: "Allow"
        Resource: "arn:aws:s3:::*"
      },
      {
        Action = [
          "sqs:GetQueueAttributes",
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:DeleteMessageBatch",
          "sqs:GetQueueUrl"
        ]
        Effect: "Allow"
        Resource: "arn:aws:sqs:*"
      }
    ]
  })
}
