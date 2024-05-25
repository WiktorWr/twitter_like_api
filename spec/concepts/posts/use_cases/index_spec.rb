# frozen_string_literal: true

describe Posts::UseCases::Index do
  subject(:fetch_posts) { described_class.new(params, user).call }

  let!(:user)       { create(:user) }
  let!(:other_user) { create(:user) }

  let!(:post_one)   { create(:post, user:, created_at: 2.days.ago) }
  let!(:post_two)   { create(:post, user:, created_at: 1.hour.ago) }
  let!(:post_three) { create(:post, user: other_user, created_at: 10.days.ago) }

  context "when user filter is invalid" do
    let!(:params) do
      {
        filters: {
          user_id: "not a number"
        }
      }
    end

    it_behaves_like "schema validation failure",
                    [
                      "user_id must be an integer"
                    ]
  end

  context "when everything is fine and no filter is applied" do
    let!(:params) { {} }

    it "returns all posts" do
      expect(fetch_posts.success).to contain_exactly(post_one, post_two, post_three)
    end
  end

  context "when everything is fine and user filter is applied" do
    let!(:params) do
      {
        filters: {
          user_id: user.id
        }
      }
    end

    it "returns all posts" do
      expect(fetch_posts.success).to contain_exactly(post_one, post_two)
    end
  end
end
