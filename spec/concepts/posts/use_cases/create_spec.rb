# frozen_string_literal: true

describe Posts::UseCases::Create do
  subject(:create_post) { described_class.new(params, user).call }

  let!(:user) { create(:user) }

  context "when params are missing" do
    let(:params) { {} }

    it_behaves_like "schema validation failure",
                    [
                      "text is missing"
                    ]
  end

  context "when params are invalid" do
    let(:params) do
      {
        text: ""
      }
    end

    it_behaves_like "schema validation failure",
                    [
                      "text must be filled"
                    ]
  end

  context "when everything is fine" do
    let(:params) do
      {
        text: "Test text"
      }
    end

    it "is success" do
      expect(create_post).to be_success
    end

    it "creates a new post" do
      expect { create_post }.to change(Post, :count).by(1)
    end
  end
end
