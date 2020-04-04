resource "aws_cognito_user_pool" "artists" {
    alias_attributes           = [
        "email",
        "preferred_username",
    ]
    arn                        = "arn:aws:cognito-idp:us-east-2:455728032032:userpool/us-east-2_TaIT9GSP2"
    auto_verified_attributes   = [
        "email",
    ]
    creation_date              = "2020-03-25T00:16:07Z"
    email_verification_message = "Your verification code is {####}. "
    email_verification_subject = "Your verification code"
    endpoint                   = "cognito-idp.us-east-2.amazonaws.com/us-east-2_TaIT9GSP2"
    last_modified_date         = "2020-03-27T02:37:25Z"
    mfa_configuration          = "OFF"
    name                       = "artists-dev"
    sms_authentication_message = "Your authentication code is {####}. "
    sms_verification_message   = "Your verification code is {####}. "
    tags                       = {}

    admin_create_user_config {
        allow_admin_create_user_only = false
        unused_account_validity_days = 1

        invite_message_template {
            email_message = "Your username is {username} and temporary password is {####}. "
            email_subject = "Your temporary password"
            sms_message   = "Your username is {username} and temporary password is {####}. "
        }
    }

    device_configuration {
        challenge_required_on_new_device      = false
        device_only_remembered_on_user_prompt = false
    }

    email_configuration {
        email_sending_account  = "DEVELOPER"
        from_email_address     = "noreply@artspot.io"
        reply_to_email_address = "noreply@artspot.io"
        source_arn             = "arn:aws:ses:us-east-1:455728032032:identity/noreply@artspot.io"
    }

    password_policy {
        minimum_length                   = 8
        require_lowercase                = true
        require_numbers                  = true
        require_symbols                  = true
        require_uppercase                = true
        temporary_password_validity_days = 1
    }

    schema {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "email"
        required                 = true

        string_attribute_constraints {
            max_length = "2048"
            min_length = "0"
        }
    }
    schema {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "name"
        required                 = true

        string_attribute_constraints {
            max_length = "2048"
            min_length = "0"
        }
    }
    schema {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "zipcode"
        required                 = false

        string_attribute_constraints {
            max_length = "9"
            min_length = "5"
        }
    }

    username_configuration {
        case_sensitive = false
    }

    verification_message_template {
        default_email_option  = "CONFIRM_WITH_LINK"
        email_message         = "Your ArtSpot verification code is {####}. "
        email_message_by_link = "Please click the link below to verify your email address. {##Verify Email##} "
        email_subject         = "Your ArtSpot  verification code"
        email_subject_by_link = "Your ArtSpot verification link"
        sms_message           = "Your ArtSpot verification code is {####} "
    }
}

resource "aws_cognito_user_pool_client" "artspot-web" {
  name = "artspot-web"
  user_pool_id = aws_cognito_user_pool.artists.id
  allowed_oauth_flows                  = []
    allowed_oauth_flows_user_pool_client = false
    allowed_oauth_scopes                 = []
    callback_urls                        = []
    explicit_auth_flows                  = [
        "ALLOW_REFRESH_TOKEN_AUTH",
    ]
    logout_urls                          = []
    prevent_user_existence_errors        = "ENABLED"
    read_attributes                      = [
        "address",
        "birthdate",
        "custom:zipcode",
        "email",
        "email_verified",
        "family_name",
        "gender",
        "given_name",
        "locale",
        "middle_name",
        "name",
        "nickname",
        "phone_number",
        "phone_number_verified",
        "picture",
        "preferred_username",
        "profile",
        "updated_at",
        "website",
        "zoneinfo",
    ]
    refresh_token_validity               = 30
    supported_identity_providers         = []
    write_attributes                     = [
        "address",
        "birthdate",
        "custom:zipcode",
        "email",
        "family_name",
        "gender",
        "given_name",
        "locale",
        "middle_name",
        "name",
        "nickname",
        "phone_number",
        "picture",
        "preferred_username",
        "profile",
        "updated_at",
        "website",
        "zoneinfo",
    ]
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "artspot.auth.us-east-2.amazoncognito.com"
}
