# frozen_string_literal: true

describe Posts::Likes::UseCases::Create do
  subject(:create_like) { described_class.new(params, user).call }

  let!(:user)           { create(:user) }
  let!(:friend)         { create(:user) }
  let!(:friendship_one) { create(:friendship, user:, friend:) }
  let!(:friendship_two) { create(:friendship, user: friend, friend: user) }
  let!(:post)           { create(:post, user: friend) }

  context "when params are missing" do
    let(:params) { {} }

    it_behaves_like "schema validation failure",
                    [
                      "id is missing"
                    ]
  end

  context "when params are invalid" do
    let(:params) do
      {
        id: -1
      }
    end

    it_behaves_like "schema validation failure",
                    [
                      "id must be greater than 0"
                    ]
  end

  context "when post is not found" do
    let(:params) do
      {
        id: 999_999_999
      }
    end

    it "fails at proper step" do
      expect(create_like.failure[0]).to eq(:check_post_existence)
    end

    it "returns proper error message" do
      expect(create_like.failure[1].first[:message]).to eq(I18n.t("errors.posts.not_found"))
    end
  end

  context "when users are not friends" do
    let(:params) do
      {
        id: post.id
      }
    end

    before do
      friendship_one.destroy!
      friendship_two.destroy!
    end

    it "fails at proper step" do
      expect(create_like.failure[0]).to eq(:check_friendship_existence)
    end

    it "returns proper error message" do
      expect(create_like.failure[1].first[:message]).to eq(I18n.t("errors.friendships.not_found"))
    end
  end

  context "when like already exists" do
    let(:params) do
      {
        id: post.id
      }
    end

    before do
      create(:like, user:, likeable: post)
    end

    it "fails at proper step" do
      expect(create_like.failure[0]).to eq(:check_if_not_liked)
    end

    it "returns proper error message" do
      expect(create_like.failure[1].first[:message]).to eq(I18n.t("errors.likes.already_exists"))
    end
  end

  context "when everything is fine" do
    let(:params) do
      {
        id: post.id
      }
    end

    it "is success" do
      expect(create_like).to be_success
    end

    it "creates like" do
      expect { create_like }.to change(Like, :count).by(1)
    end

    it "increases likes count" do
      expect { create_like }.to change{ post.reload.likes_count }.by(1)
    end
  end
end
