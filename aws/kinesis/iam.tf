resource "aws_iam_role" "firehose_role" {
  name = "firehose-role-2152"

  assume_role_policy = jsonencode({
    Version: "2012-10-17"
    Statement: [
        {
            Action: "sts:AssumeRole"
            Principal: {Service: "firehose.amazonaws.com"}
            Effect: "Allow"
            Sid: ""
        }
    ]
  })
}

resource "aws_iam_role_policy" "firehose_policy" {
  name   = "kinesis-policy-2152"
  role   = aws_iam_role.firehose_role.name
  policy = jsonencode({
      Statement: [
        {
          Effect: "Allow"
          Action: [
            "kinesis:DescribeStream",
            "kinesis:GetShardIterator",
            "kinesis:GetRecords",
            "kinesis:ListShards"
          ]
          Resource: "arn:aws:kinesis:*"
        },
        {
           Effect: "Allow"
           Action: ["kms:Decrypt", "kms:GenerateDataKey"]
           Resource: ["arn:aws:kms:*"]
        },
        {
           Effect: "Allow"
           Action: ["logs:PutLogEvents"]
           Resource: ["arn:aws:logs:*"]
        },
        {
           Effect: "Allow"
           Action: ["lambda:InvokeFunction", "lambda:GetFunctionConfiguration"]
           Resource: ["arn:aws:lambda:*"]
       },
       {
          Action: ["s3:GetObject", "s3:PutObject"]
          Effect: "Allow"
          Resource: "arn:aws:s3:::*"
       },
     ]
  })
}
