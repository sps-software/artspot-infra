resource "aws_sns_topic" "alerts" {
  name = "alerting-topic-${var.environment}"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "sms"
  endpoint  = 3017060952
}