// When you bring this back up put it in the alb
// resource "aws_lb_listener" "artspot-api" {
//   load_balancer_arn = data.terraform_remote_state.alb.outputs.arn
//   port              = "80"
//   protocol          = "HTTP"
//   // ssl_policy        = "ELBSecurityPolicy-2016-08"
//   // certificate_arn   = data.terraform_remote_state.acm.outputs.prod_api_cert_arn

//   default_action {
//     type             = "forward"
//     target_group_arn = aws_lb_target_group.tg.arn
//   }
// }

// resource "aws_lb_target_group" "tg" {
//   name     = var.target_group_name
//   port     = 8081
//   protocol = "HTTP"
//   vpc_id   =  data.terraform_remote_state.vpc.outputs.id
//   target_type = "ip"
// }

// resource "aws_cloudwatch_log_group" "artspot-api-logs" {
//   name = "artspot-api-logs"

//   tags = {
//     environment = "prod"
//   }
// }

// module "ecs-fargate-service" {
//     source              = "cn-terraform/ecs-fargate-service/aws"
//     version             = "2.0.3"
//     assign_public_ip    = true
//     name_preffix        = var.service_name
//     vpc_id              = data.terraform_remote_state.vpc.outputs.id
//     task_definition_arn = aws_ecs_task_definition.artspot-api.arn
//     ecs_cluster_name    = data.terraform_remote_state.ecs_cluster.outputs.artspot_cluster_name
//     ecs_cluster_arn     = data.terraform_remote_state.ecs_cluster.outputs.artspot_cluster_arn
//     private_subnets     = []
//     public_subnets      = data.terraform_remote_state.vpc.outputs.public_subnet_ids
//     load_balancer_sg_id = data.terraform_remote_state.security_groups.outputs.artspot_alb_tls_security_group
//     container_name      = var.container_name
//     lb_arn              = data.terraform_remote_state.alb.outputs.arn
//     lb_http_tgs_arns    = [aws_lb_target_group.tg.arn]
//     lb_http_listeners_arns = [aws_lb_listener.artspot-api.arn]
//     lb_https_listeners_arns = []
//     lb_https_tgs_arns = []
//     desired_count = 1
// }