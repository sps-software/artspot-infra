variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "deletion_protection" {
  type = bool
  default = false
}