# frozen_string_literal: true

include Dry::Monads[:result]

Doorkeeper.configure do
  orm :active_record

  resource_owner_from_credentials do |_routes|
    case Authentication::UseCases::SignIn.new(params, nil).call
    in Success(user)
      user
    in :validate, error
      message = Doorkeeper::ResponseHelper.new.prepare_json_response(
        error:,
        code:  "validation_error",
      )

      raise Doorkeeper::Errors::DoorkeeperError, message
    in :authenticate, error
      raise Doorkeeper::Errors::DoorkeeperError, "authentication"
    end
  end

  grant_flows %w[password]

  allow_blank_redirect_uri true

  skip_authorization do
    true
  end

  skip_client_authentication_for_password_grant true

  use_refresh_token

  Rails.application.config.to_prepare do
    Doorkeeper::OAuth::ErrorResponse.prepend Doorkeeper::CustomTokenErrorResponse
    Doorkeeper::OAuth::TokenResponse.prepend Doorkeeper::CustomTokenResponse
  end
end
