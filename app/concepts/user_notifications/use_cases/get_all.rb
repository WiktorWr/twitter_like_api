# frozen_string_literal: true

module UserNotifications
  module UseCases
    class GetAll < ::Monads
      def call
        fetch_notifications
      end

      private

      def fetch_notifications
        Success(::UserNotifications::Queries::GetAll.call(current_user))
      end
    end
  end
end
