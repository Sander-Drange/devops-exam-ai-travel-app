# SNS Topic for alarm notifications
resource "aws_sns_topic" "queue_age_alarm_topic" {
  name = "sqs-message-age-alarm-topic-50"  
}

# SNS Topic subscription (email)
resource "aws_sns_topic_subscription" "queue_age_alarm_email" {
  topic_arn = aws_sns_topic.queue_age_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.alarm_email  # Vi definerer denne i variables.tf
}

# CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "queue_age_alarm" {
  alarm_name          = "sqs-message-age-alarm-50"  
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name        = "ApproximateAgeOfOldestMessage"
  namespace          = "AWS/SQS"
  period             = "60"
  statistic          = "Maximum"
  threshold          = "60"
  alarm_description  = "Alert when messages are older than 5 minutes"
  alarm_actions      = [aws_sns_topic.queue_age_alarm_topic.arn]

  dimensions = {
    QueueName = aws_sqs_queue.image_queue.name
  }
}

# Histogram metric for image generation time
resource "aws_cloudwatch_metric_alarm" "image_generation_time" {
  alarm_name          = "image-generation-time-50" # Kandidatnummer
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name        = "Duration"
  namespace          = "AWS/Lambda"
  period             = "60"
  extended_statistic = "p95"  
  threshold          = "10000" # 10 seconds
  alarm_description  = "Alert when image generation takes too long"
  alarm_actions      = [aws_sns_topic.queue_age_alarm_topic.arn]

  dimensions = {
    FunctionName = "image-processor-50"
  }
}