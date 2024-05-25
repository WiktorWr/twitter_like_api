# frozen_string_literal: true

module Posts
  module Schemas
    class Create < Dry::Validation::Contract
      params do
        required(:text).filled(:string)
      end
    end
  end
end
