data "terraform_remote_state" "vpc" {
  backend = "s3"
    config = {
    # Replace this with your bucket name!
    bucket = "sps-terraform-backend"
    key    = "networking/us-east-2/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"
    config = {
    # Replace this with your bucket name!
    bucket = "sps-terraform-backend"
    key    = "networking/security_groups/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "acm" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "acm/terraform.tfstate"
    region = "us-east-2"
  }
}

module "alb" {
  source = "../../../modules/networking/alb"
  name = "artspot-alb"
  tags = {}
  subnets = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  security_groups = [
    data.terraform_remote_state.security_groups.outputs.artspot_alb_tls_security_group
  ]
}

resource "aws_lb_listener" "artspot-api" {
  load_balancer_arn = module.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.terraform_remote_state.acm.outputs.prod_api_cert_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "404"
    }
  }
}

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

resource "aws_lb_listener" "artspot-api-80-http-redirect" {
  load_balancer_arn = module.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}