# frozen_string_literal: true

describe Users::UseCases::Create do
  subject(:create_user) { described_class.new(params).call }

  let!(:user) { create(:user) }

  context "when params are missing" do
    let(:params) { {} }

    it_behaves_like "schema validation failure",
                    [
                      "first_name is missing",
                      "last_name is missing",
                      "email is missing",
                      "password is missing"
                    ]
  end

  context "when params are invalid" do
    let(:params) do
      {
        first_name: "",
        last_name:  "",
        email:      "invalid",
        password:   "invalid"
      }
    end

    it_behaves_like "schema validation failure",
                    [
                      "first_name must be filled",
                      "last_name must be filled",
                      "email is in invalid format",
                      "password is in invalid format"
                    ]
  end

  context "when user with the same email exists" do
    let(:params) do
      {
        first_name: Faker::Name.first_name,
        last_name:  Faker::Name.last_name,
        email:      user.email,
        password:   "Password100!"
      }
    end

    it "fails at proper step" do
      expect(create_user.failure[0]).to eq(:check_email_existence)
    end

    it "returns proper error message" do
      expect(create_user.failure[1].first[:message]).to eq(I18n.t("errors.users.email_exists"))
    end
  end

  context "when everything is fine" do
    let(:params) do
      {
        first_name: Faker::Name.first_name,
        last_name:  Faker::Name.last_name,
        email:      Faker::Internet.unique.email,
        password:   "Password100!"
      }
    end

    it "is success" do
      expect(create_user).to be_success
    end

    it "creates User" do
      expect { create_user }.to change(User, :count).by(1)
    end
  end
end
