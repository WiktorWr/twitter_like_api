# frozen_string_literal: true

module UserNotifications
  module UseCases
    class Read < ::Monads
      def call
        yield validate(params)
        yield check_user_notifications_existence
        yield authorize

        read_user_notifications!
        decrement_notifications_counter!
      end

      private

      def check_user_notifications_existence
        return Success() if user_notifications.size == validated_params[:ids].size

        error(I18n.t("errors.user_notifications.not_found"))
      end

      def read_user_notifications!
        user_notifications.update_all(seen: true)

        Success()
      end

      def decrement_notifications_counter!
        ::UserNotifications::Services::Counter::Decrement.new(
          current_user.id, user_notifications.size
        ).call

        Success()
      end

      # HELPER METHODS

      def schema
        ::UserNotifications::Schemas::Read.new
      end

      def policy
        ::UserNotifications::Policy.authorize(current_user, user_notifications, :read)
      end

      def user_notifications
        @user_notifications ||= UserNotification.where(id: validated_params[:ids])
      end
    end
  end
end
