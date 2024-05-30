# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      before_action do
        doorkeeper_authorize!
      end

      include Pagination

      def index
        case ::Messages::UseCases::Index.new(*params_with_current_user).call
        in Success(messages)

          _, items = cursor_paginate(messages, prepared_params)

          render json: ::Messages::Representers::Show.all(items), status: :ok
        in :validate, error
          error!(:validation_error, error, :unprocessable_entity)
        in :check_chat_existence, error
          error!(:check_chat_existence, error, :not_found)
        in :check_chat_user_existence, error
          error!(:check_chat_user_existence, error, :forbidden)
        end
      end

      def create
        case ::Messages::UseCases::Create.new(*params_with_current_user).call
        in Success(message)
          render json: ::Messages::Representers::Show.one(message), status: :created
        in :validate, error
          error!(:validation_error, error, :unprocessable_entity)
        in :check_chat_existence, error
          error!(:check_chat_existence, error, :not_found)
        in :check_chat_user_existence, error
          error!(:check_chat_user_existence, error, :forbidden)
        end
      end
    end
  end
end
