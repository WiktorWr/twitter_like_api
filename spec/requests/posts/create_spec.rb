# frozen_string_literal: true

require "swagger_helper"

describe "Posts API" do
  path "/api/v1/posts" do
    post "Create post" do
      tags "Posts"
      consumes "application/json"
      produces "application/json"

      parameter name: :params, in: :body, schema: {
        type:       :object,
        properties: {
          text: { type: :string }
        }
      }

      security ["Bearer Token": []]

      include_context "authorize_user"

      let(:params) do
        {
          text: "Test text"
        }
      end

      response "201", "create post" do
        schema type:  :object,
               allOf: [{ "$ref": "#/components/schemas/post" }]

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
    end
  end
end
