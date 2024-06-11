# frozen_string_literal: true

describe UserNotifications::UseCases::UnreadCount do
  subject(:unread_count) { described_class.new({}, user).call }

  let!(:user)                    { create(:user) }

  let!(:notification_one)        { create(:notification, :post_liked) }
  let!(:notification_two)        { create(:notification, :friendship_invitation) }
  let!(:notification_three)      { create(:notification, :friendship_invitation_accepted) }

  let!(:user_notification_one)   { create(:user_notification, notification: notification_one, user:, seen: false) }
  let!(:user_notification_two)   { create(:user_notification, notification: notification_two, user:, seen: true) }
  let!(:user_notification_three) { create(:user_notification, notification: notification_three, user:, seen: false) }

  it "returns proper unread notifications count" do
    expect(unread_count.success).to eq(2)
  end
end
