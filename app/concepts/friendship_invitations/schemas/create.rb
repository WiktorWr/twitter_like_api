# frozen_string_literal: true

module FriendshipInvitations
  module Schemas
    class Create < Dry::Validation::Contract
      params do
        required(:receiver_id).filled(:integer, gt?: 0)
      end
    end
  end
end
