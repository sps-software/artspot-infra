variable "acm_cert_arn_by_domain" {
  type = map(string)
  default = null
  description = "Mapping of acm arns by domain."
}

variable "use_same_acm_cert" {
  type = bool
  default = true
  description = "Whether to use the same ACM certificate for each of your domains. If true, only route53_zone_id will be used."
}

variable "acm_cert_arn" {
  type = string
  default = null
  description = "Sole ACM certificate to be used if use_same_acm_cert is set to true."
}

variable "domains" {
  type = list(string)
  description = "List of domains to host (without www.)"
}

variable "use_same_route53_zone" {
  type = bool
  default = true
  description = "Whether to use the same Route53 zone for each of your domains. If true, only route53_zone_id will be used."
}

variable "route53_zone_id" {
  type = string
  default = null
  description = "The sole Route53 zone to use for each of your domains if use_same_route_53_zone is set to true."
}

variable "route53_zone_ids_by_domain" {
  type = map(string)
  default = null
  description = "The Route53 Terraform ids mapped by domain."
}