# frozen_string_literal: true

module Messages
  module UseCases
    class Create < Base
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
    end
  end
end
