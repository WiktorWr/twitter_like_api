# frozen_string_literal: true

require "swagger_helper"

describe "Tokens API" do
  path "/api/v1/oauth/token" do
    post "Get access token " do
      tags "Access tokens"
      consumes "application/json"
      produces "application/json"

      parameter name: :params, in: :body, schema: {
        type:       :object,
        properties: {
          refresh_token: { type: :string },
          email:         { type: :string },
          password:      { type: :string },
          grant_type:    { type: :string },
        },
        required:   %w[scope grant_type]
      }

      request_body_example value:   {
                             email:      "john.doe@example.com",
                             password:   "password",
                             scope:      "user",
                             grant_type: "password",
                           },
                           name:    "access_token_as_user",
                           summary: "Obtain access token as user"

      request_body_example value:   { refresh_token: "RMFTakb-8kWVknGmqAHsmvWrY_aUXpBc4N2-GdHOC6I" },
                           name:    "refresh_token",
                           summary: "Refresh access token"


      let(:user)  { create(:user) }

      response "200", "sessions created" do
        schema type:       :object,
               properties: {
                 access_token:  { type: :string },
                 refresh_token: { type: :string },
                 created_at:    { type: :integer },
                 expires_in:    { type: :integer },
                 token_type:    { type: :string },
                 user_id:       { type: :integer }
               }

        context "when new access token is obtained" do
          let(:params) do
            {
              email:      user.email,
              password:   user.password,
              grant_type: "password"
            }
          end

          run_test!
        end

        context "when token is refreshed" do
          let(:params) { { refresh_token: token.refresh_token, grant_type: "refresh_token" } }

          let(:token) do
            Doorkeeper::AccessToken.find_or_create_for(
              application: nil, resource_owner: user, scopes: nil, use_refresh_token: true
            )
          end

          run_test!
        end
      end

      response "400", "invalid grant" do
        context "when params are invalid" do
          let(:params) { {} }

          run_test!
        end

        context "when invalid email or password" do
          let(:params) do
            {
              email:      user.email,
              password:   "invalid",
              grant_type: "password",
              scope:      "user"
            }
          end

          run_test!
        end
      end
    end
  end
end
