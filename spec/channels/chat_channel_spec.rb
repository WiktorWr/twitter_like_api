# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChatChannel do
  let!(:chat)      { create(:chat) }
  let!(:user)      { create(:user,) }
  let!(:chat_user) { create(:chat_user, chat:, user:) }

  let!(:chat_two)      { create(:chat) }
  let!(:user_two)      { create(:user) }
  let!(:chat_user_two) { create(:chat_user, chat: chat_two, user: user_two) }

  before do
    stub_connection(current_user: user)
  end

  context "when chat_id is invalid" do
    it "rejects subscription" do
      subscribe(chat_id: -1)
      expect(subscription).to be_rejected
    end
  end

  context "when user is not a chat user" do
    it "rejects subscription" do
      subscribe(chat_id: chat_two.id)
      expect(subscription).to be_rejected
    end
  end

  context "when chat_id is valid" do
    it "subscribes with proper chat_id" do
      subscribe(chat_id: chat.id)
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from("chat_channel_#{chat.id}")
    end
  end
end
