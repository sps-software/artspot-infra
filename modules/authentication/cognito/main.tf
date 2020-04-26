locals {
    environment_ext = "${var.environment == "" ? "" : "-"}${var.environment == "" ? "" : var.environment}"
}

resource "aws_cognito_user_pool_domain" "domain" {
    user_pool_id = aws_cognito_user_pool.artists.id
    domain       = "artspot"
}

resource "aws_cognito_user_pool" "artists" {
    alias_attributes           = [
        "email",
        "preferred_username",
    ]
    auto_verified_attributes   = [
        "email",
    ]
    mfa_configuration          = "OFF"
    name                       = "artists${local.environment_ext}"
    tags                       = {
      environment = var.environment
    }

    admin_create_user_config {
        allow_admin_create_user_only = false

        invite_message_template {
            email_message = "Your username is {username} and temporary password is {####}. "
            email_subject = "Your temporary password"
            sms_message   = "Your username is {username} and temporary password is {####}. "
        }
    }

    device_configuration {
        challenge_required_on_new_device      = true
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
        require_lowercase                = false
        require_numbers                  = false
        require_symbols                  = false
        require_uppercase                = false
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

    schema {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "promocode1"
        required                 = false

        string_attribute_constraints {
            max_length = "256"
            min_length = "1"
        }
    }

    schema {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "promocode2"
        required                 = false

        string_attribute_constraints {
            max_length = "256"
            min_length = "1"
        }
    }

    schema {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "promocode3"
        required                 = false

        string_attribute_constraints {
            max_length = "256"
            min_length = "1"
        }
    }

    sms_authentication_message = "Your authentication code is {####}. "
    verification_message_template {
        default_email_option  = "CONFIRM_WITH_LINK"
        email_message         = "Your ArtSpot verification code is {####}. "
        email_message_by_link = "Please click the link below to verify your email address. {##Verify Email##} "
        email_subject         = "Your verification code"
        email_subject_by_link = "Your ArtSpot verification link"
        sms_message           = "Your ArtSpot verification code is {####}. "
    }

}

resource "aws_cognito_user_pool_client" "artspot-web" {
    allowed_oauth_flows                  = []
    allowed_oauth_flows_user_pool_client = false
    allowed_oauth_scopes                 = []
    callback_urls                        = []
    explicit_auth_flows                  = [
        "ALLOW_REFRESH_TOKEN_AUTH",
        "ALLOW_USER_SRP_AUTH",
        // "ALLOW_USER_PASSWORD_AUTH",
        // "USER_PASSWORD_AUTH"
    ]
    logout_urls                          = []
    name                                 = "artspot-web${local.environment_ext}"
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
    user_pool_id                         = aws_cognito_user_pool.artists.id
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

resource "aws_ssm_parameter" "user_pool_id" {
  name        = "/artspot/${var.environment}/cognito/user_pool_id"
  description = "The parameter description"
  type        = "String"
  value       = aws_cognito_user_pool.artists.id

  tags = {
    environment = var.environment
  }
}

resource "aws_ssm_parameter" "user_pool_web_client_id" {
  name        = "/artspot/${var.environment}/cognito/user_pool_web_client_id"
  description = "The parameter description"
  type        = "String"
  value       = aws_cognito_user_pool_client.artspot-web.id

  tags = {
    environment = var.environment
  }
}