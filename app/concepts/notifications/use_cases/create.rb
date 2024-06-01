# frozen_string_literal: true

module Notifications
  module UseCases
    class Create < ::Monads
      def call
        yield validate(params)
        yield check_post_existence
        yield check_friendship_invitation_existence
        yield check_receivers_existence

        ActiveRecord::Base.transaction do
          notification = yield create_notification!
          user_notifications = yield create_user_notifications!(notification)
          increment_notifications_counter!(user_notifications)
          broadcast_notifications(user_notifications)
        end

        Success()
      end

      private

      def check_post_existence
        return Success() if validated_params[:post_id].nil? || post

        error(I18n.t("errors.posts.not_found"))
      end

      def check_friendship_invitation_existence
        return Success() if validated_params[:friendship_invitation_id].nil? || friendship_invitation

        error(I18n.t("errors.friendship_invitations.not_found"))
      end

      def check_receivers_existence
        return Success() if all_receivers_exist?

        error(I18n.t("errors.users.not_found"))
      end

      def create_notification!
        new_notification = Notification.create!(
          notification_type:     validated_params[:notification_type],
          text:                  notification_text(validated_params[:notification_type]),
          friendship_invitation:,
          post:,
        )

        Success(new_notification)
      end

      def create_user_notifications!(notification)
        new_user_notifications = UserNotifications::Queries::Create.call(
          notification.id, validated_params[:receiver_ids]
        )

        Success(new_user_notifications)
      end

      def increment_notifications_counter!(user_notifications)
        user_notifications.each do |user_notification|
          ::UserNotifications::Services::Counter::Increment.new(
            user_notification["user_id"]
          ).call
        end

        Success()
      end

      def broadcast_notifications(user_notifications)
        user_notifications.each do |user_notification|
          ActionCable.server.broadcast(
            "user_notifications_channel_#{user_notification['user_id']}",
            { notification: ::UserNotifications::Representers::Show.one(user_notification) }
          )
        end

        Success()
      end

      # HELPER METHODS

      def schema
        ::Notifications::Schemas::Create.new
      end

      def friendship_invitation
        @friendship_invitation ||= FriendshipInvitation.find_by(id: validated_params[:friendship_invitation_id])
      end

      def post
        @post ||= Post.find_by(id: validated_params[:post_id])
      end

      def receivers
        @receivers ||= User.where(id: validated_params[:receiver_ids])
      end

      def all_receivers_exist?
        receivers.size == validated_params[:receiver_ids].uniq.size
      end

      def notification_text(notification_type)
        case notification_type
        when Notification::NOTIFICATION_TYPES[:friendship_invitation]
          I18n.t("notifications.friendship_invitation")
        when Notification::NOTIFICATION_TYPES[:post_liked]
          I18n.t("notifications.post_liked")
        end
      end
    end
  end
end
