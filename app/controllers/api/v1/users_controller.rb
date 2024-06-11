# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      before_action only: [:index, :unread_notifications_count] do
        doorkeeper_authorize!
      end

      include Pagination

      def index
        case ::Users::UseCases::Index.new(prepared_params).call
        in Success(users)

          _, items = cursor_paginate(users, prepared_params)

          render json: ::Users::Representers::Show.all(items)
        end
      end

      def create
        case ::Users::UseCases::Create.new(prepared_params).call
        in Success
          head :created
        in :validate, error
          error!(:validation_error, error, :unprocessable_entity)
        in :check_email_existence, _
          head :created # I don't want to expose information whether an account exists
        end
      end

      def unread_notifications_count
        render json: {
          count: ::UserNotifications::UseCases::UnreadCount.new(*params_with_current_user).call.success
        }, status: :ok
      end
    end
  end
end
