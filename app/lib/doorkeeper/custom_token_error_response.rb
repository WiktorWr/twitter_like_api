# frozen_string_literal: true

module Doorkeeper
  module CustomTokenErrorResponse
    def body
      {
        error: {
          code:    name,
          details: [
            {
              key:     "_base",
              message: description
            }
          ]
        }
      }
    end
  end
end
