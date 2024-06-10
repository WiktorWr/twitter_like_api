# frozen_string_literal: true

describe UserNotifications::UseCases::Read do
  subject(:read_user_notifications) { described_class.new(params, user_one).call }

  let!(:user_one) { create(:user) }
  let!(:user_two) { create(:user) }

  let!(:notification_one) { create(:notification, :friendship_invitation) }
  let!(:notification_two) { create(:notification, :post_liked) }

  let!(:user_one_notification_one) { create(:user_notification, notification: notification_one, user: user_one) }
  let!(:user_one_notification_two) { create(:user_notification, notification: notification_two, user: user_one, seen: true) }
  let!(:user_two_notification_one) { create(:user_notification, notification: notification_two, user: user_two) }

  context "when params are missing" do
    let!(:params) { {} }

    it_behaves_like "schema validation failure",
                    [
                      "ids is missing"
                    ]
  end

  context "when params are invalid" do
    let!(:params) do
      {
        ids: []
      }
    end

    it_behaves_like "schema validation failure",
                    [
                      "ids must be filled",
                    ]
  end

  context "when user notification is not found" do
    let!(:params) do
      {
        ids: [999_999_999]
      }
    end

    it "fails at proper step" do
      expect(read_user_notifications.failure[0]).to eq(:check_user_notifications_existence)
    end

    it "returns proper error message" do
      expect(read_user_notifications.failure[1].first[:message]).to eq(I18n.t("errors.user_notifications.not_found"))
    end
  end

  context "when user notification is not authorized" do
    let!(:params) do
      {
        ids: [user_two_notification_one.id]
      }
    end

    it "fails at proper step" do
      expect(read_user_notifications.failure[0]).to eq(:authorize)
    end

    it "returns proper error message" do
      expect(read_user_notifications.failure[1].first[:message]).to eq(I18n.t("errors.common.access_forbidden"))
    end
  end

  context "when everything is fine" do
    let!(:params) do
      {
        ids: [user_one_notification_one.id, user_one_notification_two.id]
      }
    end

    before do
      RedisStore.current.set("user_#{user_one.id}_notifications_count", "1")
    end

    it "is success" do
      expect(read_user_notifications).to be_success
    end

    it "updates seen flag for the first user notification" do
      expect {
        read_user_notifications
      }.to change { user_one_notification_one.reload.seen }.from(false).to(true)
    end

    it "does not update seen flag for the second user notification" do
      expect {
        read_user_notifications
      }.not_to(change { user_one_notification_two.reload.seen })
    end

    it "decreases user counter" do
      read_user_notifications
      expect(RedisStore.current.get("user_#{user_one.id}_notifications_count")).to eq("0")
    end

    it "broadcast value to the user channel" do
      expect { read_user_notifications }.to(
        have_broadcasted_to("user_notifications_counter_channel_#{user_one.id}").exactly(:once).with(
          { count: "0" }
        )
      )
    end
  end
end
