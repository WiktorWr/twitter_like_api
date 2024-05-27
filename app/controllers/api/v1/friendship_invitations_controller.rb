# frozen_string_literal: true

module Api
  module V1
    class FriendshipInvitationsController < BaseController
      before_action do
        doorkeeper_authorize!
      end

      def create
        case ::FriendshipInvitations::UseCases::Create.new(*params_with_current_user).call
        in Success(friendship_invitation)
          render json: ::FriendshipInvitations::Representers::Show.one(friendship_invitation), status: :created
        in :validate, error
          error!(:validation_error, error, :unprocessable_entity)
        in :check_receiver_existence, error
          error!(:check_receiver_existence, error, :not_found)
        in :check_if_receiver_is_not_sender, error
          error!(:check_if_receiver_is_not_sender, error, :conflict)
        in :check_if_users_are_friends, error
          error!(:check_if_users_are_friends, error, :conflict)
        in :check_pending_invitation_existence, error
          error!(:check_pending_invitation_existence, error, :conflict)
        end
      end
    end
  end
end
