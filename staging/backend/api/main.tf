data "terraform_remote_state" "acm" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "acm/terraform.tfstate"
    region = "us-east-2"
  }
}

module "api" {
  source = "../../../modules/backend/api"
  cert_arn = data.terraform_remote_state.acm.outputs.staging_api_cert_arn
  environment = "staging"
}

// data "terraform_remote_state" "vpc" {
//   backend = "s3"
//     config = {
//     # Replace this with your bucket name!
//     bucket = "sps-terraform-backend"
//     key    = "networking/us-east-2/terraform.tfstate"
//     region = "us-east-2"
//   }
// }

// data "terraform_remote_state" "security_groups" {
//   backend = "s3"
//     config = {
//     # Replace this with your bucket name!
//     bucket = "sps-terraform-backend"
//     key    = "networking/security_groups/terraform.tfstate"
//     region = "us-east-2"
//   }
// }

// data "aws_ssm_parameter" "cancelation-api-lambda-arn" {
//   name = "/artspot/${var.environment}/api/cancelation-lambda"
// }

// module "alb" {
//   source = "../../networking/alb"
//   name = "artspot-alb-${var.environment}"
//   tags = {}
//   subnets = data.terraform_remote_state.vpc.outputs.public_subnet_ids
//   security_groups = [
//     data.terraform_remote_state.security_groups.outputs.artspot_alb_tls_security_group
//   ]
// }

// // add only sg to lambda to make it only available via alb
// resource "aws_lambda_permission" "cancelation_with_lb" {
//   statement_id  = "AllowExecutionFromlb"
//   action        = "lambda:InvokeFunction"
//   function_name = data.aws_ssm_parameter.cancelation-api-lambda-arn.value
//   principal     = "elasticloadbalancing.amazonaws.com"
//   source_arn    = aws_lb_target_group.cancelation-api.arn
// }

// resource "aws_lb_target_group" "cancelation-api" {
//   name     = "cancelation-api-${var.environment}"
//   port     = 443
//   protocol = "HTTPS"
//   // vpc_id   = data.terraform_remote_state.vpc.outputs.id
//   target_type = "lambda"
//   health_check {
//     path = "/health_check"
//     matcher = 200
//     interval = 35
//   }
// }

// resource "aws_lb_target_group_attachment" "alb_tg_attachment_staging" {
//   target_group_arn = aws_lb_target_group.cancelation-api-staging.arn
//   target_id        = data.aws_ssm_parameter.cancelation-api-lambda-arn.value
//   depends_on       = [aws_lambda_permission.with_lb]
// }

// resource "aws_lb_listener" "artspot-api-80-http-redirect" {
//   load_balancer_arn = module.alb.arn
//   port              = "80"
//   protocol          = "HTTP"

//   default_action {
//     type = "redirect"

//     redirect {
//       port        = "443"
//       protocol    = "HTTPS"
//       status_code = "HTTP_301"
//     }
//   }
// }

// resource "aws_lb_listener" "artspot-api-staging" {
//   load_balancer_arn = module.alb.arn
//   port              = "443"
//   protocol          = "HTTPS"
//   ssl_policy        = "ELBSecurityPolicy-2016-08"
//   certificate_arn   = data.terraform_remote_state.acm.outputs.staging_api_cert_arn

//   default_action {
//     type = "fixed-response"

//     fixed_response {
//       content_type = "text/plain"
//       message_body = "Fixed response content"
//       status_code  = "404"
//     }
//   }
// }

// resource "aws_lb_listener_rule" "cancelation-listener" {
//   listener_arn = aws_lb_listener.artspot-api-staging.arn
//   priority     = 1

//   action {
//     type = "forward"
//     target_group_arn = aws_lb_target_group.cancelation-api-staging.arn 
//   }

//   condition {
//     path_pattern {
//       values = ["/cancel-membership"]
//     }
//   }
// }