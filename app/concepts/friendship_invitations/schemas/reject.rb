# frozen_string_literal: true

module FriendshipInvitations
  module Schemas
    class Reject < Dry::Validation::Contract
      params do
        required(:id).filled(:integer, gt?: 0)
      end
    end
  end
end
