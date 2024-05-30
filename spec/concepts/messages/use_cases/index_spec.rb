# frozen_string_literal: true

describe Messages::UseCases::Index do
  subject(:index_messages) { described_class.new(params, user_one).call }

  let!(:user_one)   { create(:user) }
  let!(:user_two)   { create(:user) }

  let!(:chat)            { create(:chat) }
  let!(:chat_user_one)   { create(:chat_user, chat:, user: user_one) }
  let!(:chat_user_two)   { create(:chat_user, chat:, user: user_two) }

  let!(:message_one) do
    create(
      :message,
      chat:,
      chat_user:  chat_user_one,
      created_at: DateTime.current - 2.days
    )
  end
  let!(:message_two) do
    create(
      :message,
      chat:,
      chat_user:  chat_user_two,
      created_at: DateTime.current - 1.day
    )
  end
  let!(:message_three) do
    create(
      :message,
      chat:,
      chat_user:  chat_user_one,
      created_at: DateTime.current - 5.hours
    )
  end

  let!(:other_message) { create(:message) }

  context "when params are missing" do
    let!(:params) { {} }

    it "is failure" do
      expect(index_messages).to be_failure
    end

    it_behaves_like "schema validation failure",
                    [
                      "id is missing"
                    ]
  end

  context "when params are invalid" do
    let!(:params) do
      {
        id: -1
      }
    end

    it "is failure" do
      expect(index_messages).to be_failure
    end

    it_behaves_like "schema validation failure",
                    [
                      "id must be greater than 0"
                    ]
  end

  context "when chat is not found" do
    let!(:params) do
      {
        id: 999_999_999
      }
    end

    it "fails at proper step" do
      expect(index_messages.failure[0]).to eq(:check_chat_existence)
    end

    it "returns proper error message" do
      expect(index_messages.failure[1].first[:message]).to eq(I18n.t("errors.chats.not_found"))
    end
  end

  context "when chat user is not found" do
    let!(:params) do
      {
        id: chat.id
      }
    end

    before do
      chat_user_one.destroy!
    end

    it "fails at proper step" do
      expect(index_messages.failure[0]).to eq(:check_chat_user_existence)
    end

    it "returns proper error message" do
      expect(index_messages.failure[1].first[:message]).to eq(I18n.t("errors.chat_users.not_found"))
    end
  end

  context "when everything is fine" do
    let!(:params) do
      {
        id: chat.id
      }
    end

    it "is success" do
      expect(index_messages).to be_success
    end

    it "returns messages" do
      expect(index_messages.success).to contain_exactly(
        message_one, message_two, message_three
      )
    end
  end
end
