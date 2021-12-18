resource "aws_sqs_queue" "landing_queue" {
  name                       = "landing-queue-2152"
  visibility_timeout_seconds = 120
}
