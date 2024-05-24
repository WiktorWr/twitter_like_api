# frozen_string_literal: true

module Doorkeeper
  class ResponseHelper
    include ApiError

    def prepare_json_response(error:, code:)
      response = {
        error: error_message(code, error)
      }
      response.to_json
    end
  end
end
