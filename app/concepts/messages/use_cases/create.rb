# frozen_string_literal: true

module Messages
  module UseCases
    class Create < ::Monads
      def call
        yield validate(params)
        yield check_chat_existence
        yield check_chat_user_existence

        ActiveRecord::Base.transaction do
          message = yield create_message!
          yield broadcast_message(message)

          Success(message)
        end
      end

      private

      def check_chat_existence
        return Success() if chat

        error(I18n.t("errors.chats.not_found"))
      end

      def check_chat_user_existence
        return Success() if chat_user

        error(I18n.t("errors.chat_users.not_found"))
      end

      def create_message!
        message = Message.create!(
          text:      validated_params[:text],
          chat_user:,
          chat:
        )

        Success(message)
      end

      def broadcast_message(message)
        ActionCable.server.broadcast(
          "chat_channel_#{chat.id}",
          { message: Messages::Representers::Show.one(message) }
        )

        Success()
      end

      # HELPER METHODS

      def schema
        ::Messages::Schemas::Create.new
      end

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
