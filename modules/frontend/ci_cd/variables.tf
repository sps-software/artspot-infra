variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "deploy_bucket" {
  type = string
}

variable "sourceBranch" {
  type = string
  default = "master"
}