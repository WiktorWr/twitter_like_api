# frozen_string_literal: true

module UserNotifications
  module Representers
    class Show < ::Representer
      represent_with :id,
                     :seen,
                     :notification,
                     :created_at

      private

      def notification
        ::Notifications::Representers::Show.one(resource.notification)
      end
    end
  end
end
