# TODO get all missing records in here... not too pressed.
# somewhat managed by AWS
# Website records are actually managed by the hosting module

locals {
  prod-api-dubs = "www.${var.prod-api}"
  staging-api-dubs = "www.${var.staging-api}"
}

// no-dubs staging api A record
resource "aws_route53_record" "A_record_staging_api" {
  zone_id = data.terraform_remote_state.hosting.outputs.hosted_zone_id
  name = var.staging-api
  type = "A"
  alias {
    name = data.terraform_remote_state.us-east-2-alb-staging.outputs.lb_dns_name
    zone_id  = data.terraform_remote_state.us-east-2-alb-staging.outputs.lb_zone_id
    evaluate_target_health = false
  }
}

// no-dubs staging api AAAA record
resource "aws_route53_record" "AAAA_record_staging_api" {
  zone_id = data.terraform_remote_state.hosting.outputs.hosted_zone_id
  name = var.staging-api
  type = "AAAA"
  alias {
    name = data.terraform_remote_state.us-east-2-alb-staging.outputs.lb_dns_name
    zone_id  = data.terraform_remote_state.us-east-2-alb-staging.outputs.lb_zone_id
    evaluate_target_health = false
  }
}

// dubs staging api A record
resource "aws_route53_record" "www_A_record_staging_api" {
  zone_id = data.terraform_remote_state.hosting.outputs.hosted_zone_id
  name = local.staging-api-dubs
  type = "A"
  alias {
    name = data.terraform_remote_state.us-east-2-alb-staging.outputs.lb_dns_name
    zone_id  = data.terraform_remote_state.us-east-2-alb-staging.outputs.lb_zone_id
    evaluate_target_health = false
  }
}

// dubs staging api AAAA record
resource "aws_route53_record" "www_AAAA_record_staging_api" {
  zone_id = data.terraform_remote_state.hosting.outputs.hosted_zone_id
  name = local.staging-api-dubs
  type = "AAAA"
  alias {
    name = data.terraform_remote_state.us-east-2-alb-staging.outputs.lb_dns_name
    zone_id  = data.terraform_remote_state.us-east-2-alb-staging.outputs.lb_zone_id
    evaluate_target_health = false
  }
}


// // no-dubs prod api A record
// resource "aws_route53_record" "A_record_prod_api" {
//   zone_id = data.terraform_remote_state.hosting.outputs.hosted_zone_id
//   name = var.prod-api
//   type = "A"
//   alias {
//     name = data.terraform_remote_state.us-east-2-alb-prod.outputs.lb_dns_name
//     zone_id  = data.terraform_remote_state.us-east-2-alb-prod.outputs.lb_zone_id
//     evaluate_target_health = false
//   }
// }

// // no-dubs staging api AAAA record
// resource "aws_route53_record" "AAAA_record_prod_api" {
//   zone_id = data.terraform_remote_state.hosting.outputs.hosted_zone_id
//   name = var.prod-api
//   type = "AAAA"
//   alias {
//     name = data.terraform_remote_state.us-east-2-alb-prod.outputs.lb_dns_name
//     zone_id  = data.terraform_remote_state.us-east-2-alb-prod.outputs.lb_zone_id
//     evaluate_target_health = false
//   }
// }

// // dubs staging api A record
// resource "aws_route53_record" "www_A_record_prod_api" {
//   zone_id = data.terraform_remote_state.hosting.outputs.hosted_zone_id
//   name = local.prod-api-dubs
//   type = "A"
//   alias {
//     name = data.terraform_remote_state.us-east-2-alb-prod.outputs.lb_dns_name
//     zone_id  = data.terraform_remote_state.us-east-2-alb-prod.outputs.lb_zone_id
//     evaluate_target_health = false
//   }
// }

// // dubs staging api AAAA record
// resource "aws_route53_record" "www_AAAA_record_prod_api" {
//   zone_id = data.terraform_remote_state.hosting.outputs.hosted_zone_id
//   name = local.prod-api-dubs
//   type = "AAAA"
//   alias {
//     name = data.terraform_remote_state.us-east-2-alb-prod.outputs.lb_dns_name
//     zone_id  = data.terraform_remote_state.us-east-2-alb-prod.outputs.lb_zone_id
//     evaluate_target_health = false
//   }
// }