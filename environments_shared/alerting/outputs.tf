output "alerting_sns_arn" {
  value = aws_sns_topic.alerts.arn
}