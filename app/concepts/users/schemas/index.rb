# frozen_string_literal: true

module Users
  module Schemas
    class Index < Dry::Validation::Contract
      params do
        optional(:filters).hash do
          optional(:query).maybe(:string)
        end
      end
    end
  end
end