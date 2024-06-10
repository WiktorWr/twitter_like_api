# frozen_string_literal: true

describe UserNotifications::UseCases::GetAll do
  subject(:get_user_notifications) { described_class.new(nil, user_one).call }

  let!(:user_one) { create(:user) }
  let!(:user_two) { create(:user) }

  let!(:notification_one)   { create(:notification, :friendship_invitation) }
  let!(:notification_two)   { create(:notification, :post_liked) }
  let!(:notification_three) { create(:notification, :friendship_invitation_accepted) }

  let!(:user_one_notification_one) { create(:user_notification, notification: notification_one, user: user_one, created_at: 1.day.ago) }
  let!(:user_one_notification_two) { create(:user_notification, notification: notification_two, user: user_one, created_at: 1.minute.ago) }
  let!(:user_two_notification_one) { create(:user_notification, notification: notification_three, user: user_two) }

  context "when everything is fine" do
    it "returns proper user notifications" do
      expect(get_user_notifications.success).to contain_exactly(user_one_notification_one, user_one_notification_two)
    end
  end
end
