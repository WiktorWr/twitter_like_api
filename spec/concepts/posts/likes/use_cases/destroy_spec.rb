# frozen_string_literal: true

describe Posts::Likes::UseCases::Destroy do
  subject(:destroy_like) { described_class.new(params, user).call }

  let!(:user)           { create(:user) }
  let!(:friend)         { create(:user) }
  let!(:friendship_one) { create(:friendship, user:, friend:) }
  let!(:friendship_two) { create(:friendship, user: friend, friend: user) }
  let!(:post)           { create(:post, user: friend) }
  let!(:like)           { create(:like, user:, likeable: post) }

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
      expect(destroy_like.failure[0]).to eq(:check_post_existence)
    end

    it "returns proper error message" do
      expect(destroy_like.failure[1].first[:message]).to eq(I18n.t("errors.posts.not_found"))
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
      expect(destroy_like.failure[0]).to eq(:check_friendship_existence)
    end

    it "returns proper error message" do
      expect(destroy_like.failure[1].first[:message]).to eq(I18n.t("errors.friendships.not_found"))
    end
  end

  context "when like does not exist" do
    let(:params) do
      {
        id: post.id
      }
    end

    before do
      like.destroy!
    end

    it "fails at proper step" do
      expect(destroy_like.failure[0]).to eq(:check_if_liked)
    end

    it "returns proper error message" do
      expect(destroy_like.failure[1].first[:message]).to eq(I18n.t("errors.likes.not_found"))
    end
  end

  context "when everything is fine" do
    let(:params) do
      {
        id: post.id
      }
    end

    it "is success" do
      expect(destroy_like).to be_success
    end

    it "destroys like" do
      destroy_like
      expect { like.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "decreases likes count in the database" do
      expect { destroy_like }.to change(Like, :count).by(-1)
    end

    it "decreases post's likes count" do
      expect { destroy_like }.to change{ post.reload.likes_count }.by(-1)
    end
  end
end
