# frozen_string_literal: true

module Api
  module V1
    class PostLikesController < BaseController
      before_action do
        doorkeeper_authorize!
      end

      def create
        case ::Posts::Likes::UseCases::Create.new(*params_with_current_user).call
        in Success
          head :created
        in :validate, error
          error!(:validation_error, error, :unprocessable_entity)
        in :check_post_existence, error
          error!(:check_post_existence, error, :not_found)
        in :check_friendship_existence, error
          error!(:check_friendship_existence, error, :not_found)
        in :check_if_not_liked, error
          error!(:check_if_not_liked, error, :conflict)
        end
      end

      def destroy
        case ::Posts::Likes::UseCases::Destroy.new(*params_with_current_user).call
        in Success
          head :ok
        in :validate, error
          error!(:validation_error, error, :unprocessable_entity)
        in :check_post_existence, error
          error!(:check_post_existence, error, :not_found)
        in :check_friendship_existence, error
          error!(:check_friendship_existence, error, :not_found)
        in :check_if_liked, error
          error!(:check_if_liked, error, :conflict)
        end
      end
    end
  end
end
