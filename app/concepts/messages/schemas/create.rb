# frozen_string_literal: true

module Messages
  module Schemas
    class Create < ::ApplicationContract
      params do
        required(:id).filled(:integer, gt?: 0)
        required(:text).filled(:string)
      end
    end
  end
end
