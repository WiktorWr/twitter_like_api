# frozen_string_literal: true

module UserNotifications
  class Policy < Policy
    def read?
      resource.all? { |r| r.user_id == user.id }
    end
  end
end
