# frozen_string_literal: true

module Authentication
  module Schemas
    class SignIn < Dry::Validation::Contract
      params do
        required(:email).filled(:string)
        required(:password).filled(:string)
      end
    end
  end
end
