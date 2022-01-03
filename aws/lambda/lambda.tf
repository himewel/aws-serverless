resource "aws_lambda_function" "landing_to_sqs_lambda" {
  function_name = "landing_to_sqs-2152"
  depends_on    = [aws_iam_role_policy.logs_policy]
  image_uri     = "343221145296.dkr.ecr.sa-east-1.amazonaws.com/functions-2152:latest"
  package_type  = "Image"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 120

  image_config {
    command = ["landing_to_sqs.lambda_handler"]
  }
}

resource "aws_lambda_permission" "allow_bucket_lambda_alias" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.landing_to_sqs_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.landing_bucket.arn
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

resource "aws_lambda_function" "sqs_to_ingested_lambda" {
  function_name = "sqs_to_ingested-2152"
  depends_on    = [aws_iam_role_policy.logs_policy]
  image_uri     = "343221145296.dkr.ecr.sa-east-1.amazonaws.com/functions-2152:latest"
  package_type  = "Image"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 120

  image_config {
    command = ["sqs_to_ingested.lambda_handler"]
  }
}

resource "aws_lambda_event_source_mapping" "sqs_notification" {
  event_source_arn = "arn:aws:sqs:sa-east-1:343221145296:landing-queue-2152"
  function_name    = aws_lambda_function.sqs_to_ingested_lambda.arn
}
