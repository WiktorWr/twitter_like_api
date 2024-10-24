# frozen_string_literal: true

describe UserNotifications::Services::Counter::Decrement do
  subject(:decrement_counter) { described_class.new(user_id).call }

  let!(:user)                    { create(:user) }
  let!(:user_id)                 { user.id }

  let!(:notification_one)        { create(:notification, :friendship_invitation) }
  let!(:notification_two)        { create(:notification, :friendship_invitation_accepted) }
  let!(:notification_three)      { create(:notification, :post_liked) }

  let!(:user_notification_one)   { create(:user_notification, notification: notification_one, user:, seen: false) }
  let!(:user_notification_two)   { create(:user_notification, notification: notification_two, user:, seen: true) }
  let!(:user_notification_three) { create(:user_notification, notification: notification_three, user:, seen: false) }

  let!(:amount) { nil }

  context "when user is not found" do
    let!(:user_id) { 999_999 }

    it "fails at proper step" do
      expect(decrement_counter.failure[0]).to eq(:check_user_existence)
    end

    it "contains proper error message" do
      expect(decrement_counter.failure[1].first[:message]).to eq(I18n.t("errors.users.not_found"))
    end
  end

  context "when cached value does not exist" do
    before do
      RedisStore.current.flushdb
    end

    it "is success" do
      expect(decrement_counter).to be_success
    end

    it "creates proper redis key" do
      decrement_counter
      expect(RedisStore.current).to exist("user_#{user_id}_notifications_count")
    end

    it "sets proper counter" do
      decrement_counter
      expect(RedisStore.current.get("user_#{user_id}_notifications_count")).to eq("2")
    end

    it "broadcasts value to the proper channel" do
      expect { decrement_counter }.to(
        have_broadcasted_to("user_notifications_counter_channel_#{user_id}").exactly(:once).with(
          { count: "2" }
        )
      )
    end
  end

  context "when cached value exists" do
    before do
      RedisStore.current.set("user_#{user_id}_notifications_count", "10")
    end

    it "is success" do
      expect(decrement_counter).to be_success
    end

    it "decreases counter" do
      decrement_counter
      expect(RedisStore.current.get("user_#{user_id}_notifications_count")).to eq("9")
    end

    it "broadcasts value to the proper channel" do
      expect { decrement_counter }.to(
        have_broadcasted_to("user_notifications_counter_channel_#{user_id}").exactly(:once).with(
          { count: "9" }
        )
      )
    end
  end

  context "when specific amount is passed" do
    subject(:decrement_counter) { described_class.new(user_id, amount).call }

    let!(:amount) { 6 }

    before do
      RedisStore.current.set("user_#{user_id}_notifications_count", "10")
    end

    it "is success" do
      expect(decrement_counter).to be_success
    end

    it "decreases counter" do
      decrement_counter
      expect(RedisStore.current.get("user_#{user_id}_notifications_count")).to eq("4")
    end

    it "broadcasts value to the proper channel" do
      expect { decrement_counter }.to(
        have_broadcasted_to("user_notifications_counter_channel_#{user_id}").exactly(:once).with(
          { count: "4" }
        )
      )
    end
  end
end
