
// import this first
resource "aws_lb_listener" "artspot-api" {
  load_balancer_arn = data.terraform_remote_state.alb.outputs.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.terraform_remote_state.acm.outputs.staging_api_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group" "tg" {
  name     = var.target_group_name
  port     = 443
  protocol = "HTTPS"
  vpc_id   =  data.terraform_remote_state.vpc.outputs.id
}

module "ecs-fargate-service" {
    source              = "cn-terraform/ecs-fargate-service/aws"
    version             = "2.0.3"
    name_preffix        = var.service_name
    vpc_id              = data.terraform_remote_state.vpc.outputs.id
    task_definition_arn = aws_ecs_task_definition.artspot-api.arn
    ecs_cluster_name    = data.terraform_remote_state.ecs_cluster.outputs.artspot_cluster_name
    ecs_cluster_arn     = data.terraform_remote_state.ecs_cluster.outputs.artspot_cluster_arn
    private_subnets     = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    public_subnets      = []
    lb_arn              = data.terraform_remote_state.alb.outputs.arn
    lb_http_tgs_arns    = [aws_lb_target_group.tg.arn]
    load_balancer_sg_id = data.terraform_remote_state.security_groups.outputs.artspot_alb_tls_security_group
    container_name      = var.container_name
    lb_http_listeners_arns = []
    lb_https_listeners_arns = [aws_lb_listener.artspot-api.arn]
    lb_https_tgs_arns = [aws_lb_target_group.tg.arn]
}