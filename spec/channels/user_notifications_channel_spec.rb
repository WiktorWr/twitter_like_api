# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserNotificationsChannel do
  let!(:user) { create(:user) }

  context "when user is not found" do
    it "rejects subscription" do
      subscribe(user_id: -1)
      expect(subscription).to be_rejected
    end
  end

  context "when user is found" do
    it "subscribes with proper user_id" do
      subscribe(user_id: user.id)
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from("user_notifications_channel_#{user.id}")
    end
  end
end
