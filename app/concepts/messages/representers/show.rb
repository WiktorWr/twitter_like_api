# frozen_string_literal: true

module Messages
  module Representers
    class Show < ::Representer
      represent_with :id,
                     :text,
                     :user_first_name,
                     :user_last_name,
                     :user_email,
                     :created_at

      private

      def user_first_name
        resource.chat_user.user&.first_name
      end

      def user_last_name
        resource.chat_user.user&.last_name
      end

      def user_email
        resource.chat_user.user&.email
      end
    end
  end
end
