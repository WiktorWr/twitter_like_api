# frozen_string_literal: true

module Notifications
  module Schemas
    class Create < ::ApplicationContract
      params do
        required(:notification_type).filled(:string, included_in?: Notification::NOTIFICATION_TYPES.values)
        required(:receiver_ids).filled(:array).each(:integer, gt?: 0)
        optional(:post_id).maybe(:integer, gt?: 0)
        optional(:friendship_invitation_id).maybe(:integer, gt?: 0)
      end
    end
  end
end
