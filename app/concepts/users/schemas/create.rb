# frozen_string_literal: true

module Users
  module Schemas
    class Create < ::ApplicationContract
      params do
        required(:first_name).filled(Types::StrippedString)
        required(:last_name).filled(Types::StrippedString)
        required(:email).filled(::Types::EmailString, format?: EMAIL_FORMAT)
        required(:password).filled(
          :string,
          format?:   PASSWORD_FORMAT,
          min_size?: PASSWORD_MIN_LENGTH
        )
      end
    end
  end
end
