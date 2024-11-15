resource "aws_lambda_function" "image_processor" {
  filename         = "lambda_function.zip"
  function_name    = "image-processor-50"  # Kandidatnummer i navnet
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_sqs.lambda_handler"
  runtime         = "python3.8"
  timeout         = 30

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.image_queue.url
      S3_BUCKET = "pgr301-couch-explorers"
    }
  }
}