variable "name" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "aws_region" {    
  default = "us-east-2"
  type = string
}

variable "environment" {
  default = ""
  type = string
}

variable "artifactsEnabled" {
  default = true
  type = bool
}

variable "sourceProvider" {
  default = "GitHub"
  type = string
}

variable "sourceOwner" {
  default = "ThirdParty"
  type = string
}

variable "sourceBranch" {
  default = "master"
  type = string
}

variable "sourceGithubUser" {
  type = string
}

variable "sourceRepo" {
  type = string
}

variable "pollForSourceChanges" {
  default = true
  type = bool
}

variable "stages" {
  type = list(
    object({
      name = string,
      actions = list(
        object({
          category = string,
          configuration = map(string),
          input_artifacts = list(string),
          name = string,
          output_artifacts = list(string),
          provider = string,
        })
      )
    })
  )
} 

variable "tags" {
  default = {}
  type = map
}