# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      before_action do
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
    end
  end
end
