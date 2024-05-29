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
          chat = yield create_chat
          create_chat_users(chat.id)
          accept_invitation
        end
      end

      private

      def create_friendships
        Friendship.upsert_all(new_friendships)

        Success()
      end

      def create_chat
        chat = Chat.create!

        Success(chat)
      end

      def create_chat_users(chat_id)
        new_chat_users = [current_user.id, friendship_invitation.sender_id].map do |user_id|
          {
            user_id:,
            chat_id:
          }
        end

        ChatUser.upsert_all(new_chat_users)

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
