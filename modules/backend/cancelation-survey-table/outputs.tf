output "arn" {
  value = aws_dynamodb_table.cancelation-survey-table.arn
}

output "id" {
  value = aws_dynamodb_table.cancelation-survey-table.id
}

output "stream_arn" {
  value = aws_dynamodb_table.cancelation-survey-table.stream_arn
}

output "stream_label" {
  value = aws_dynamodb_table.cancelation-survey-table.stream_label
}