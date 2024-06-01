# frozen_string_literal: true

require "swagger_helper"

describe "Chat Messages API" do
  path "/api/v1/chats/{id}/messages" do
    get "Gets chat messages" do
      tags "Chat Messages"
      consumes "application/json"
      produces "application/json"

      security ["Bearer Token": []]

      parameter name: :id, in: :path, type: :integer
      parameter name: :oldest_item_id, in: :query, required: false, schema: { type: :integer, description: "Pass to get previous messages" }

      include_context "authorize_user"

      let!(:user_two) { create(:user) }

      let!(:chat)            { create(:chat) }
      let!(:chat_user_one)   { create(:chat_user, chat:, user:) }
      let!(:chat_user_two)   { create(:chat_user, chat:, user: user_two) }

      let!(:message_one) do
        create(
          :message,
          chat:,
          chat_user:  chat_user_one,
          created_at: DateTime.current - 2.days
        )
      end
      let!(:message_two) do
        create(
          :message,
          chat:,
          chat_user:  chat_user_two,
          created_at: DateTime.current - 1.day
        )
      end
      let!(:message_three) do
        create(
          :message,
          chat:,
          chat_user:  chat_user_one,
          created_at: DateTime.current - 5.hours
        )
      end

      let(:id) { chat.id }

      response "200", "gets chat messages" do
        schema type:  :array,
               items: {
                 allOf: [{ "$ref": "#/components/schemas/message" }]
               }

        context "without oldest_item_id" do
          run_test!
        end

        context "with oldest_item_id" do
          let(:oldest_item_id) { message_two.id }

          run_test!
        end
      end

      response "401", "unauthorized" do
        let(:Authorization) { "Bearer invalid" }

        run_test!
      end

      response "422", "invalid params" do
        let(:id) { "abc" }

        run_test!
      end

      response "404", "not found" do
        let(:id) { chat.id + 1 }

        run_test!
      end

      response "403", "forbidden" do
        before do
          chat_user_one.destroy!
        end

        run_test!
      end
    end
  end
end
