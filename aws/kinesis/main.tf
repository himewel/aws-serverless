resource "aws_kinesis_stream" "ingested_stream" {
  name = "ingested-stream-2152"

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }
}

resource "aws_s3_bucket" "ingested_bucket" {
  bucket = "ingested-2152"
}

resource "aws_kinesis_firehose_delivery_stream" "ingested_firehose" {
  name        = "ingested-firehose-2152"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.ingested_stream.arn
    role_arn = aws_iam_role.firehose_role.arn
  }

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.ingested_bucket.arn
    buffer_size        = 128
    buffer_interval    = 60
    prefix = "weather_measures/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
    error_output_prefix = "error=!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
  }
}
