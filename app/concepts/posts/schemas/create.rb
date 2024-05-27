# frozen_string_literal: true

module Posts
  module Schemas
    class Create < ::ApplicationContract
      params do
        required(:text).filled(Types::StrippedString)
      end
    end
  end
end
