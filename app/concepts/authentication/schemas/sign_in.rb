# frozen_string_literal: true

module Authentication
  module Schemas
    class SignIn < ::ApplicationContract
      params do
        required(:email).filled(::Types::EmailString, format?: EMAIL_FORMAT)
        required(:password).filled(:string)
      end
    end
  end
end
