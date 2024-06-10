# frozen_string_literal: true

module UserNotifications
  module Queries
    class GetAll
      class << self
        def call(user)
          UserNotification.joins(:notification)
                          .where(user_id: user.id)
                          .order(created_at: :desc)
        end
      end
    end
  end
end
