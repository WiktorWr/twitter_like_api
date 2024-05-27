# frozen_string_literal: true

module FriendshipInvitations
  module UseCases
    class Accept < Base
      def call
        yield validate(params)
        yield check_invitation_existence
        yield authorize
        yield check_invitation_status

        ActiveRecord::Base.transaction do
          create_friendships
          accept_invitation
        end
      end

      private

      def create_friendships
        Friendship.upsert_all(new_friendships)

        Success()
      end

      def accept_invitation
        friendship_invitation.accept

        Success(friendship_invitation)
      end

      # HELPER METHODS

      def schema
        ::FriendshipInvitations::Schemas::Accept.new
      end

      def policy
        ::FriendshipInvitations::Policy.authorize(current_user, friendship_invitation, :accept)
      end

      def new_friendships
        [
          {
            user_id:   current_user.id,
            friend_id: friendship_invitation.sender_id
          },
          {
            user_id:   friendship_invitation.sender_id,
            friend_id: current_user.id
          }
        ]
      end
    end
  end
end
