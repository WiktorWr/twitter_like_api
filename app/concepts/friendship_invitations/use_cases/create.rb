# frozen_string_literal: true

module FriendshipInvitations
  module UseCases
    class Create < ::Monads
      def call
        yield validate(params)
        yield check_receiver_existence
        yield check_if_receiver_is_not_sender
        yield check_if_users_are_friends
        yield check_pending_invitation_existence

        create_invitation!
      end

      private

      def check_receiver_existence
        return Success() if receiver

        error(I18n.t("errors.users.not_found"))
      end

      def check_if_receiver_is_not_sender
        return Success() unless receiver == current_user

        error(I18n.t("errors.friendship_invitations.receiver_is_sender"))
      end

      def check_if_users_are_friends
        return Success() unless friendship_exists?

        error(I18n.t("errors.friendship_invitations.users_are_friends"))
      end

      def check_pending_invitation_existence
        return Success() unless pending_invitation_exists?

        error(I18n.t("errors.friendship_invitations.pending_invitation_exists"))
      end

      def create_invitation!
        friendship_invitation = FriendshipInvitation.create!(sender: current_user, receiver:)

        Success(friendship_invitation)
      end

      # HELPER METHODS

      def schema
        ::FriendshipInvitations::Schemas::Create.new
      end

      def receiver
        @receiver ||= User.find_by(id: validated_params[:receiver_id])
      end

      def friendship_exists?
        Friendship.exists?(user: current_user, friend: receiver) || Friendship.exists?(user: receiver, friend: current_user)
      end

      def pending_invitation_exists?
        FriendshipInvitation.exists?(
          sender:            current_user,
          receiver:,
          invitation_status: FriendshipInvitation::INVIATION_STATUSES[:pending]
        ) ||
          FriendshipInvitation.exists?(
            sender:            receiver,
            receiver:          current_user,
            invitation_status: FriendshipInvitation::INVIATION_STATUSES[:pending]
          )
      end
    end
  end
end
