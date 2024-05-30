# frozen_string_literal: true

module Messages
  module UseCases
    class Base < ::Monads
      private

      def check_chat_existence
        return Success() if chat

        error(I18n.t("errors.chats.not_found"))
      end

      def check_chat_user_existence
        return Success() if chat_user

        error(I18n.t("errors.chat_users.not_found"))
      end

      # HELPER METHODS

      def chat
        @chat ||= Chat.includes(chat_users: :user)
                      .find_by(id: validated_params[:id])
      end

      def chat_user
        @chat_user ||= chat.chat_users.find { |cu| cu.user_id == current_user&.id }
      end
    end
  end
end
