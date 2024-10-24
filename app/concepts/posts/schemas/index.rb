# frozen_string_literal: true

module Posts
  module Schemas
    class Index < ::ApplicationContract
      params do
        optional(:filters).hash do
          optional(:user_id).maybe(:integer)
        end
      end
    end
  end
end
