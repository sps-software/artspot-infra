provider "aws" {
  alias = "east1"
  region = "us-east-1"
}

provider "aws" {
  alias = "east2"
  region = "us-east-2"
}