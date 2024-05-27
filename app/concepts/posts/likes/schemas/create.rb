# frozen_string_literal: true

module Posts
  module Likes
    module Schemas
      class Create < Dry::Validation::Contract
        params do
          required(:id).filled(:integer, gt?: 0)
        end
      end
    end
  end
end
