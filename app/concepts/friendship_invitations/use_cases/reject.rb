# frozen_string_literal: true

module FriendshipInvitations
  module UseCases
    class Reject < Base
      def call
        yield validate(params)
        yield check_invitation_existence
        yield authorize
        yield check_invitation_status

        reject_invitation
      end

      private

      def reject_invitation
        friendship_invitation.reject

        Success(friendship_invitation)
      end

      # HELPER METHODS

      def schema
        ::FriendshipInvitations::Schemas::Reject.new
      end

      def policy
        ::FriendshipInvitations::Policy.authorize(current_user, friendship_invitation, :reject)
      end
    end
  end
end
