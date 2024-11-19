# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role_50"

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

# IAM Policy for Lambda to Access SQS, S3, and Bedrock
resource "aws_iam_policy" "lambda_access_policy" {
  name        = "Lambda_access_policy_50"
  description = "IAM policy for Lambda to interact with SQS, S3, and Bedrock"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        # Permissions for SQS
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        Effect = "Allow",
        Resource = "${aws_sqs_queue.image_queue.arn}"
        #Resource = "arn:aws:sqs:eu-west-1:244530008913:image-generation-queue-50"
      },
      {
        # Permissions for S3
        Action = [
          "s3:PutObject"
        ],
        Effect = "Allow",
        Resource = "arn:aws:s3:::pgr301-couch-explorers/50/generated-images-2/*"
      },
      {
        # Permissions for Bedrock
        Action = [
          "bedrock:InvokeModel"
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Attach main IAM Policy to Lambda Execution Role
resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_access_policy.arn
}

# Attach CloudWatch Logs policy
resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}