resource "aws_sqs_queue" "image_queue" {
  name                       = "image-generation-queue-50"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400
}