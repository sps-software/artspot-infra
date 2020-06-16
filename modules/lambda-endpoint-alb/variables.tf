variable "environment" {
  type = string
}

variable "lb_arn" {
  type = string
}

variable "lambda_arn" {
  type = string
}

variable "cert_arn" {
  type = string
  default = null
}

variable "https" { 
  type = bool
  default = true
}

variable "health_check_path" {
  type = string
  default = "/health_check"
}

variable "health_check_port" {
  type = number
  default = 443
}

variable "health_check_protocol" {
  type = string
  default = "HTTPS"
}

variable "health_check_matcher" {
  type = number
  default = 200
}

variable "health_check_interval" {
  type = number
  default = 35
}

variable "health_check_timeout" {
  type = number
  default = 30
}

variable "use_alt_listener_port" {
  type = bool
  default = false
}

variable "alt_listener_port" {
  type = number
  default = null
}

variable "alt_listener_protocol" {
  type = number
  default = null
}

variable "listener_priority" {
  type = number
  default = 1
}

variable "path_patterns" {
 type = list(string)
}