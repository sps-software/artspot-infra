module "cognito" {
    source = "../../../environments_shared/backend/authentication/cognito"
    environment = "prod"
    domain = "artspot"
}