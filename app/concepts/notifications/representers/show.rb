# frozen_string_literal: true

module Notifications
  module Representers
    class Show < ::Representer
      represent_with :text,
                     :notification_type,
                     :post_id,
                     :friendship_invitation_id
    end
  end
end
