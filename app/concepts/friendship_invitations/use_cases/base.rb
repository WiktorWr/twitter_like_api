# frozen_string_literal: true

module FriendshipInvitations
  module UseCases
    class Base < ::Monads
      private

      def check_invitation_existence
        return Success() if friendship_invitation

        error(I18n.t("errors.friendship_invitations.not_found"))
      end

      def check_invitation_status
        return Success() if friendship_invitation.pending?

        error(I18n.t("errors.friendship_invitations.not_pending"))
      end

      # HELPER METHODS

      def friendship_invitation
        @friendship_invitation ||= FriendshipInvitation.find_by(id: validated_params[:id])
      end
    end
  end
end
