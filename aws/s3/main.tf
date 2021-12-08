resource "aws_s3_bucket" "landing_bucket" {
  bucket = "landing-2152"
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = "app-2152"
}
