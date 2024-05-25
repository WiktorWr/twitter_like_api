# frozen_string_literal: true

module Api
  module V1
    class PostsController < BaseController
      before_action do
        doorkeeper_authorize!
      end

      include Pagination

      def index
        case ::Posts::UseCases::Index.new(*params_with_current_user).call
        in Success(posts)

          _, items = cursor_paginate(posts, prepared_params)

          render json: ::Posts::Representers::Show.all(items)
        in :validate, error
          error!(:validation_error, error, :unprocessable_entity)
        end
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
