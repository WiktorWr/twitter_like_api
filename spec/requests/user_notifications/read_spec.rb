# frozen_string_literal: true

require "swagger_helper"

describe "User Notifications API" do
  path "/api/v1/user_notifications/read" do
    post "Reads user notifications" do
      tags "[WEB] User Notifications"
      consumes "application/json"
      produces "application/json"

      security ["Bearer Token": []]

      parameter name: :params, in: :body, schema: {
        type:       :object,
        properties: {
          ids: { type: :array, items: { type: :integer } }
        },
      }

      include_context "authorize_user"

      let!(:notification_one)        { create(:notification, :post_liked) }
      let!(:notification_two)        { create(:notification, :friendship_invitation) }
      let!(:notification_three)      { create(:notification, :friendship_invitation_accepted) }
      let!(:user_notification_one)   { create(:user_notification, notification: notification_one, user:) }
      let!(:user_notification_two)   { create(:user_notification, notification: notification_two, user:) }
      let!(:user_notification_three) { create(:user_notification, notification: notification_three, user:) }
      let!(:ids)                     { [user_notification_one.id, user_notification_two.id, user_notification_three.id] }
      let!(:params)                  { { ids: } }

      response "200", "reads user notifications" do
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { "Bearer invalid" }

        run_test!
      end

      response "422", "invalid params" do
        let!(:ids) { [-1] }

        run_test!
      end

      response "404", "not found" do
        let!(:ids) { [999_999_999] }

        run_test!
      end

      response "403", "forbidden" do
        before do
          user_notification_one.update!(user: create(:user))
        end

        run_test!
      end
    end
  end
end
