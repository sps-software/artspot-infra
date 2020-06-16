locals {
  environment_ext = "${var.environment == "" ? "" : "-"}${var.environment == "" ? "" : var.environment}"
}

resource "aws_dynamodb_table" "cancelation-survey-table" {
  name           = "CancelationSurvey${local.environment_ext}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "UserEmail"
  range_key      = "DateTime"

  attribute {
    name = "UserEmail"
    type = "S"
  }

  attribute {
    name = "DateTime"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags = {
    Name        = "cancelation-survey-table${local.environment_ext}"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "cancelation_table_arn" {
  type = "String"
  name = "/artspot/${var.environment}/api/cancelation-table"
  value = aws_dynamodb_table.cancelation-survey-table.arn
}