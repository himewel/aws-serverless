resource "aws_s3_bucket" "landing_bucket" {
  bucket = "landing-2152"
}

resource "aws_iam_role" "role_lambda" {
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
  role   = aws_iam_role.role_lambda.name
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

resource "aws_lambda_function" "landing_to_sqs_lambda" {
  function_name = "landing_to_sqs-2152"
  depends_on    = [aws_iam_role_policy.logs_policy]
  image_uri     = "343221145296.dkr.ecr.sa-east-1.amazonaws.com/functions-2152:latest"
  package_type  = "Image"
  role          = aws_iam_role.role_lambda.arn
  timeout       = 120

  image_config {
    command = ["landing_to_sqs.lambda_handler"]
  }
}

resource "aws_lambda_permission" "allow_bucket_lambda_alias" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.landing_to_sqs_lambda.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.landing_bucket.arn}"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket     = aws_s3_bucket.landing_bucket.id
  depends_on = [aws_lambda_permission.allow_bucket_lambda_alias]

  lambda_function {
    lambda_function_arn = aws_lambda_function.landing_to_sqs_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".csv"
  }
}
