# frozen_string_literal: true

require "swagger_helper"

describe "Users API" do
  path "/api/v1/users/{id}/unread_notifications_count" do
    get "Get unread notifications count" do
      tags "[WEB] Users"
      consumes "application/json"
      produces "application/json"

      security ["Bearer Token": []]

      parameter name: :id, in: :path, type: :integer

      let!(:notification_one)        { create(:notification, :post_liked) }
      let!(:notification_two)        { create(:notification, :friendship_invitation) }
      let!(:notification_three)      { create(:notification, :friendship_invitation_accepted) }

      let!(:user_notification_one)   { create(:user_notification, notification: notification_one, user:, seen: false) }
      let!(:user_notification_two)   { create(:user_notification, notification: notification_two, user:, seen: false) }
      let!(:user_notification_three) { create(:user_notification, notification: notification_three, user:, seen: false) }

      let(:id) { user.id }

      include_context "authorize_user"

      response "200", "get unread notifications count" do
        schema type:       :object,
               properties: {
                 count: { type: :integer }
               }

        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { "Bearer invalid" }

        run_test!
      end
    end
  end
end
