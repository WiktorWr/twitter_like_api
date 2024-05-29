# frozen_string_literal: true

describe Messages::UseCases::Create do
  subject(:create_message) { described_class.new(params, user_one).call }

  let!(:user_one)   { create(:user) }
  let!(:user_two)   { create(:user) }
  let!(:user_three) { create(:user) }

  let!(:chat)          { create(:chat) }
  let!(:chat_user_one) { create(:chat_user, chat:, user: user_one) }
  let!(:chat_user_two) { create(:chat_user, chat:, user: user_two) }

  context "when params are missing" do
    let!(:params) { {} }

    it "is failure" do
      expect(create_message).to be_failure
    end

    it_behaves_like "schema validation failure",
                    [
                      "id is missing",
                      "text is missing"
                    ]
  end

  context "when params are invalid" do
    let!(:params) do
      {
        id:   -1,
        text: "",
      }
    end

    it "is failure" do
      expect(create_message).to be_failure
    end

    it_behaves_like "schema validation failure",
                    [
                      "id must be greater than 0",
                      "text must be filled"
                    ]
  end

  context "when chat is not found" do
    let!(:params) do
      {
        id:   chat.id + 1,
        text: "Hello",
      }
    end

    it "fails at proper step" do
      expect(create_message.failure[0]).to eq(:check_chat_existence)
    end

    it "returns proper error message" do
      expect(create_message.failure[1].first[:message]).to eq(I18n.t("errors.chats.not_found"))
    end
  end

  context "when user is not chat user" do
    let!(:params) do
      {
        id:   chat.id,
        text: "Hello",
      }
    end

    before do
      chat_user_one.destroy!
    end

    it "fails at proper step" do
      expect(create_message.failure[0]).to eq(:check_chat_user_existence)
    end

    it "returns proper error message" do
      expect(create_message.failure[1].first[:message]).to eq(I18n.t("errors.chat_users.not_found"))
    end
  end

  context "when everything is fine" do
    let!(:params) do
      {
        id:   chat.id,
        text: "Hello",
      }
    end

    it "is success" do
      expect(create_message).to be_success
    end

    it "creates message" do
      expect { create_message }.to change(Message, :count).by(1)
    end

    it "broadcasts message to proper chat channel" do
      expect { create_message }.to(
        have_broadcasted_to("chat_channel_#{chat.id}").with(
          Messages::Representers::Show.one(Message.last)
        )
      )
    end
  end
end
