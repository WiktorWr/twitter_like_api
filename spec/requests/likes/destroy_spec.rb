# frozen_string_literal: true

require "swagger_helper"

describe "Post likes API" do
  path "/api/v1/posts/{id}/likes" do
    delete "Delete post like" do
      tags "Post Likes"
      consumes "application/json"
      produces "application/json"

      parameter name: :id, in: :path, type: :integer, required: true

      security ["Bearer Token": []]

      include_context "authorize_user"

      let!(:friend)         { create(:user) }
      let!(:friendship_one) { create(:friendship, user:, friend:) }
      let!(:friendship_two) { create(:friendship, user: friend, friend: user) }
      let!(:friend_post)    { create(:post, user: friend) }
      let!(:like)           { create(:like, user:, likeable: friend_post) }
      let!(:id)             { friend_post.id }

      response "200", "delete like" do
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { "Bearer invalid" }

        run_test!
      end

      response "422", "invalid params" do
        let!(:id) { -1 }

        run_test!
      end

      response "404", "not found" do
        context "when post is not found" do
          let(:id) { friend_post.id + 1 }

          run_test!
        end

        context "when friendship is not found" do
          before do
            friendship_one.destroy!
            friendship_two.destroy!
          end

          run_test!
        end
      end

      response "409", "conflict" do
        before do
          like.destroy!
        end

        run_test!
      end
    end
  end
end
