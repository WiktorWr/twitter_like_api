# frozen_string_literal: true

module UserNotifications
  module Schemas
    class Read < ::ApplicationContract
      params do
        required(:ids).filled(:array).each(:integer, gt?: 0)
      end
    end
  end
end
