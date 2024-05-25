# frozen_string_literal: true

module Api
  module V1
    class PostsController < BaseController
      before_action do
        doorkeeper_authorize!
      end

      def create
        case ::Posts::UseCases::Create.new(*params_with_current_user).call
        in Success(post)
          render json: ::Posts::Representers::Show.one(post), status: :created
        in :validate, error
          error!(:validation_error, error, :unprocessable_entity)
        end
      end
    end
  end
end
