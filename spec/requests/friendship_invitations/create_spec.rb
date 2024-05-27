# frozen_string_literal: true

require "swagger_helper"

describe "Friendship invitations API" do
  path "/api/v1/friendship_invitations" do
    post "Create friendship invitation" do
      tags "Friendship Invitations"
      consumes "application/json"
      produces "application/json"

      parameter name: :params, in: :body, schema: {
        type:       :object,
        properties: {
          receiver_id: { type: :integer }
        }
      }

      security ["Bearer Token": []]

      include_context "authorize_user"

      let!(:other_user) { create(:user) }

      let!(:params) do
        {
          receiver_id: other_user.id
        }
      end

      response "201", "create friendship invitation" do
        schema type:  :object,
               allOf: [{ "$ref": "#/components/schemas/friendship_invitation" }]

        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { "Bearer invalid" }

        run_test!
      end

      response "422", "invalid params" do
        let(:params) { {} }

        run_test!
      end

      response "404", "not found" do
        let!(:params) do
          {
            receiver_id: 999_999_999
          }
        end

        run_test!
      end

      response "409", "conflict" do
        context "when sender and receiver are the same user" do
          let!(:params) do
            {
              receiver_id: user.id
            }
          end

          run_test!
        end

        context "when pending invitation already exists" do
          let!(:params) do
            {
              receiver_id: other_user.id
            }
          end

          before do
            create(:friendship_invitation, sender: user, receiver: other_user)
          end

          run_test!
        end

        context "when users are already friends" do
          let!(:params) do
            {
              receiver_id: other_user.id
            }
          end

          before do
            create(:friendship, user:, friend: other_user)
            create(:friendship, user: other_user, friend: user)
          end

          run_test!
        end
      end
    end
  end
end
