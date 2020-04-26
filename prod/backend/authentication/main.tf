module "cognito" {
    source = "../../../modules/authentication/cognito"
    environment = "prod"
}