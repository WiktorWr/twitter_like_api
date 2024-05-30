# frozen_string_literal: true

module Messages
  module Schemas
    class Index < ApplicationContract
      params do
        required(:id).filled(:integer, gt?: 0)
      end
    end
  end
end
