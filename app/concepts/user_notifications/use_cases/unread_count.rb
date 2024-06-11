# frozen_string_literal: true

module UserNotifications
  module UseCases
    class UnreadCount < ::Monads
      def call
        Success(unread_count)
      end

      private

      # HELPER METHODS

      def unread_count
        @unread_count ||= UserNotification.where(user_id: current_user.id, seen: false).size
      end
    end
  end
end
