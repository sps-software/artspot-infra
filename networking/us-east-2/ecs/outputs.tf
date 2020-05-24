output "artspot_cluster_name" {
  value = var.name
}

output "artspot_cluster_id" {
  value = aws_ecs_cluster.artspot.id
}

output "artspot_cluster_arn" {
  value = aws_ecs_cluster.artspot.arn
}