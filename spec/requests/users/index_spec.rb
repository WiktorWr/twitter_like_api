# frozen_string_literal: true

require "swagger_helper"

describe "Users API" do
  path "/api/v1/users" do
    get "Get list of users" do
      tags "Users"
      consumes "application/json"
      produces "application/json"

      security ["Bearer Token": []]

      parameter name: :oldest_item_id, in: :query, required: false, schema: { type: :integer, description: "Provide to get previous users" }
      parameter name: :filters, in: :query, required: false, schema: {
        type:       :object,
        properties: {
          query: { type: :string },
        },
      }, style: "deepObject", explode: true

      include_context "authorize_user"

      let!(:other_user_one)   { create(:user) }
      let!(:other_user_two)   { create(:user) }
      let!(:other_user_three) { create(:user) }

      response "200", "gets users" do
        schema type:  :array,
               items: {
                 allOf: [{ "$ref": "#/components/schemas/user" }]
               }

        context "with query filter" do
          let(:filters) do
            {
              query: other_user_one.first_name.last(2)
            }
          end

          run_test!
        end

        context "with oldest_item_id" do
          let(:oldest_item_id) { other_user_two.id }

          run_test!
        end

        context "without any filter" do
          run_test!
        end
      end
    end
  end
end
