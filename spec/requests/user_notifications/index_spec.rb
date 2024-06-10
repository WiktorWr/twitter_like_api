# frozen_string_literal: true

require "swagger_helper"

describe "User Notifications API" do
  path "/api/v1/user_notifications" do
    get "Get list of usernotifications" do
      tags "User Notifications"
      consumes "application/json"
      produces "application/json"

      security ["Bearer Token": []]

      parameter name: :oldest_item_id, in: :query, required: false, schema: { type: :integer, description: "Provide to get previous user notifications" }

      include_context "authorize_user"

      let!(:notification_one)   { create(:notification, :friendship_invitation) }
      let!(:notification_two)   { create(:notification, :post_liked) }
      let!(:notification_three) { create(:notification, :friendship_invitation_accepted) }

      let!(:user_notification_one)   { create(:user_notification, notification: notification_one, user:, created_at: 1.day.ago) }
      let!(:user_notification_two)   { create(:user_notification, notification: notification_two, user:, created_at: 1.minute.ago) }
      let!(:user_notification_three) { create(:user_notification, notification: notification_three, user:, created_at: 1.second.ago) }

      response "200", "gets user notifications" do
        schema type:  :array,
               items: {
                 allOf: [{ "$ref": "#/components/schemas/user_notification" }]
               }

        context "with oldest_item_id" do
          let(:oldest_item_id) { user.id }

          run_test!
        end

        context "without oldest_item_id" do
          run_test!
        end
      end
    end
  end
end
