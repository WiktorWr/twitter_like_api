# frozen_string_literal: true

describe Authentication::UseCases::SignIn do
  subject(:sign_in) { described_class.new(params).call }

  let!(:user) { create(:user, password: "password") }

  context "when invalid params" do
    let(:params) do
      {
        token: {
          email: "test@example.com"
        }
      }
    end

    it_behaves_like "schema validation failure",
                    [
                      "email is missing",
                      "password is missing"
                    ]
  end

  context "when password is invalid" do
    let(:params) do
      {
        email:    user.email,
        password: "invalid-password",
        scope:    "user"
      }
    end

    it "returns proper error message" do
      expect(sign_in.failure[1].last[:message]).to eq(I18n.t("errors.sessions.authentication"))
    end
  end

  context "when everything is fine" do
    let(:params) do
      {
        email:    user.email,
        password: user.password,
      }
    end

    context "when user logging in" do
      it "returns user" do
        expect(sign_in.success).to eq(user)
      end
    end
  end
end
