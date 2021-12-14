resource "aws_ecr_repository" "functions_ecr" {
  name = "functions-2152"

  image_scanning_configuration {
    scan_on_push = true
  }
}
