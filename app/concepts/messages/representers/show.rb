# frozen_string_literal: true

module Messages
  module Representers
    class Show < ::Representer
      represent_with :id,
                     :text,
                     :created_at,
                     :user

      private

      def user
        ::Users::Representers::Show.one(resource.chat_user.user)
      end
    end
  end
end
