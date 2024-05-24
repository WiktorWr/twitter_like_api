# frozen_string_literal: true

module Doorkeeper
  module CustomTokenResponse
    def body
      additional_data = {
        user_id: @token.resource_owner_id
      }

      super.merge(additional_data)
    end
  end
end
