# frozen_string_literal: true

require "swagger_helper"

describe "Posts API" do
  path "/api/v1/posts" do
    get "Get list of posts" do
      tags "Posts"
      consumes "application/json"
      produces "application/json"

      security ["Bearer Token": []]

      parameter name: :oldest_item_id, in: :query, required: false, schema: { type: :integer, description: "Provide to get previous posts" }
      parameter name: :filters, in: :query, required: false, schema: {
        type:       :object,
        properties: {
          user_id: { type: :integer },
        },
      }, style: "deepObject", explode: true

      include_context "authorize_user"

      let!(:other_user) { create(:user) }

      let!(:post_one)   { create(:post, user:, created_at: 2.days.ago) }
      let!(:post_two)   { create(:post, user:, created_at: 1.hour.ago) }
      let!(:post_three) { create(:post, user: other_user, created_at: 5.minutes.ago) }
      let!(:post_four)  { create(:post, user:, created_at: 1.minute.ago) }

      response "200", "gets posts" do
        schema type:  :array,
               items: {
                 allOf: [{ "$ref": "#/components/schemas/post" }]
               }

        context "with user filter" do
          let(:filters) do
            {
              user_id: user.id
            }
          end

          run_test!
        end

        context "with oldest_item_id" do
          let(:oldest_item_id) { post_three.id }

          run_test!
        end

        context "without any filter" do
          run_test!
        end
      end

      response "422", "invalid params" do
        let(:filters) do
          {
            user_id: "not a number"
          }
        end

        run_test!
      end
    end
  end
end
