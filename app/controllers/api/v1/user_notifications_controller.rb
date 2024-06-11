# frozen_string_literal: true

module Api
  module V1
    class UserNotificationsController < BaseController
      before_action do
        doorkeeper_authorize!
      end

      include Pagination

      def index
        case ::UserNotifications::UseCases::GetAll.new(*params_with_current_user).call
        in Success(user_notifications)

          _, items = cursor_paginate(user_notifications, prepared_params)

          render json: ::UserNotifications::Representers::Show.all(items)
        end
      end

      def read
        case ::UserNotifications::UseCases::Read.new(*params_with_current_user).call
        in Success
          head :ok
        in :validate, error
          error!(:validation_error, error, :unprocessable_entity)
        in :authorize, error
          error!(:authorize, error, :forbidden)
        in :check_user_notifications_existence, error
          error!(:check_user_notifications_existence, error, :not_found)
        end
      end
    end
  end
end
