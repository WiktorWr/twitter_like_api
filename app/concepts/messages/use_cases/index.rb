# frozen_string_literal: true

module Messages
  module UseCases
    class Index < Base
      def call
        yield validate(params)
        yield check_chat_existence
        yield check_chat_user_existence

        fetch_messages
      end

      private

      def fetch_messages
        messages = Message
                   .select(<<-SQL.squish)
                      messages.id,
                      messages.text,
                      messages.created_at,
                      users.first_name AS user_first_name,
                      users.last_name AS user_last_name
                   SQL
                   .left_joins(chat_user: :user )
                   .where(chat_id: chat.id)

        Success(messages)
      end

      # HELPER METHODS

      def schema
        ::Messages::Schemas::Index.new
      end
    end
  end
end
