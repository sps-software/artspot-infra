module "cognito" {
    source = "../../../environments_shared/backend/authentication/cognito"
    environment = "dev"
    domain = "artspot-dev"
}