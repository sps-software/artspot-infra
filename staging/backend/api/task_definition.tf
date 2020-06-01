resource "aws_ecs_task_definition" "artspot-api" {
  execution_role_arn = data.terraform_remote_state.iam_roles.outputs.ecs-task-execution-role-arn
  family                = "hello-world"
  container_definitions = file("container_definitions.json")
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 256
  memory = 512
}