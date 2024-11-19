output "sqs_queue_url" {
  # Outputs the SQS queue URL for easy reference.
  description = "URL of the SQS queue"
  value       = aws_sqs_queue.image_queue.url
}

output "lambda_function_name" {
  # Outputs the Lambda function name, useful for debugging and integration.
  description = "Name of the Lambda function"
  value       = aws_lambda_function.image_processor.function_name
}