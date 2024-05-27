# frozen_string_literal: true

module FriendshipInvitations
  module Schemas
    class Reject < ::ApplicationContract
      params do
        required(:id).filled(:integer, gt?: 0)
      end
    end
  end
end
