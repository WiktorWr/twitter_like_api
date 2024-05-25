# frozen_string_literal: true

describe Users::UseCases::Index do
  subject(:index_users) { described_class.new(params).call }

  let!(:user_one)   { create(:user, first_name: "aaa", last_name: "111") }
  let!(:user_two)   { create(:user, first_name: "bbb", last_name: "222") }
  let!(:user_three) { create(:user, first_name: "abc", last_name: "123") }

  context "when query filter is not applied" do
    let(:params) { {} }

    it "returns all posts" do
      expect(index_users.success).to contain_exactly(user_one, user_two, user_three)
    end
  end

  context "when query filter is applied" do
    let(:params) do
      {
        filters: {
          query: "a"
        }
      }
    end

    it "returns filtered users" do
      expect(index_users.success).to contain_exactly(user_one, user_three)
    end
  end
end
