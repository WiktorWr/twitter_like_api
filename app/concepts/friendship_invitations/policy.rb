# frozen_string_literal: true

module FriendshipInvitations
  class Policy < Policy
    def accept?
      user.id == resource.receiver_id
    end

    def reject?
      user.id == resource.receiver_id
    end
  end
end
