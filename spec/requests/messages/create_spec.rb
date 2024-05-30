# frozen_string_literal: true

require "swagger_helper"

describe "Chat Messages API" do
  path "/api/v1/chats/{id}/messages" do
    post "Creates chat message" do
      tags "Chat Messages"
      consumes "application/json"
      produces "application/json"

      security ["Bearer Token": []]

      parameter name: :id, in: :path, type: :integer

      parameter name: :params, in: :body, schema: {
        type:       :object,
        properties: {
          text: { type: :string }
        }
      }

      include_context "authorize_user"

      let!(:chat)      { create(:chat) }
      let!(:chat_user) { create(:chat_user, chat:, user:) }

      let(:id) { chat.id }
      let(:params) do
        {
          text: "Hello"
        }
      end

      response "201", "creates message" do
        schema type:  :object,
               allOf: [{ "$ref": "#/components/schemas/message" }]

        run_test!
      end

      response "422", "invalid params" do
        let(:params) do
          {
            text: ""
          }
        end

        run_test!
      end

      response "404", "not found" do
        let(:id) { chat.id + 1 }

        run_test!
      end

      response "403", "forbidden" do
        before do
          chat_user.destroy!
        end

        run_test!
      end
    end
  end
end
