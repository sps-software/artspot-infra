module "cognito" {
    source = "../../../environments_shared/backend/authentication/cognito"
    environment = "staging"
    domain = "artspot-staging"
}