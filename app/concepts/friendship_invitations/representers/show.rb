# frozen_string_literal: true

module FriendshipInvitations
  module Representers
    class Show < ::Representer
      represent_with :id,
                     :receiver,
                     :sender,
                     :invitation_status,
                     :created_at

      private

      def receiver
        ::Users::Representers::Show.one(resource.receiver)
      end

      def sender
        ::Users::Representers::Show.one(resource.sender)
      end
    end
  end
end
