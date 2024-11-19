data "archive_file" "lambda_zip" {
  # Prepares the Python script as a ZIP file to be used as the Lambda function's code package.
  type        = "zip"
  source_file = "../lambda_sqs.py" # Points to the existing Python file.
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "image_processor" {
  filename         = "lambda_function.zip"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name    = "image-processor-50"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_sqs.lambda_handler"
  runtime          = "python3.8"
  timeout          = 50

  environment {
    variables = {
      BUCKET_NAME = "pgr301-couch-explorers"
      QUEUE_URL   = aws_sqs_queue.image_queue.url
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.image_queue.arn
  function_name    = aws_lambda_function.image_processor.function_name
  batch_size       = 1
}