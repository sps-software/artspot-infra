module "cognito" {
    source = "../../../modules/authentication/cognito"
    environment = "staging"
    domain = "artspot-staging"
}