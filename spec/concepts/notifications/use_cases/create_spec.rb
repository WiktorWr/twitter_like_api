# frozen_string_literal: true

describe Notifications::UseCases::Create do
  subject(:create_notification) { described_class.new(params).call }

  let!(:user)           { create(:user) }
  let!(:post)           { create(:post, user:) }
  let!(:invitation_one) { create(:friendship_invitation, receiver: user) }
  let!(:invitation_two) { create(:friendship_invitation, sender: user, status: FriendshipInvitation::STATUSES[:accepted]) }

  context "when params are missing" do
    let!(:params) { {} }

    it_behaves_like "schema validation failure",
                    [
                      "notification_type is missing",
                      "receiver_ids is missing"
                    ]
  end

  context "when params are invalid" do
    let!(:params) do
      {
        notification_type:        "invalid",
        receiver_ids:             [],
        post_id:                  -1,
        friendship_invitation_id: -1
      }
    end

    it_behaves_like "schema validation failure",
                    [
                      "notification_type must be one of: #{Notification::NOTIFICATION_TYPES.values.join(', ')}",
                      "receiver_ids must be filled",
                      "post_id must be greater than 0",
                      "friendship_invitation_id must be greater than 0"
                    ]
  end

  context "when post is not found" do
    let!(:params) do
      {
        notification_type: Notification::NOTIFICATION_TYPES[:post_liked],
        receiver_ids:      [user.id],
        post_id:           999_999_999
      }
    end

    it "fails at proper step" do
      expect(create_notification.failure[0]).to eq(:check_post_existence)
    end

    it "returns proper error message" do
      expect(create_notification.failure[1].first[:message]).to eq(I18n.t("errors.posts.not_found"))
    end
  end

  context "when friendship invitation is not found" do
    let!(:params) do
      {
        notification_type:        Notification::NOTIFICATION_TYPES[:friendship_invitation_accepted],
        receiver_ids:             [user.id],
        friendship_invitation_id: 999_999_999
      }
    end

    it "fails at proper step" do
      expect(create_notification.failure[0]).to eq(:check_friendship_invitation_existence)
    end

    it "returns proper error message" do
      expect(create_notification.failure[1].first[:message]).to eq(I18n.t("errors.friendship_invitations.not_found"))
    end
  end

  context "when receiver is not found" do
    let!(:params) do
      {
        notification_type:        Notification::NOTIFICATION_TYPES[:friendship_invitation_accepted],
        receiver_ids:             [user.id, 999_999_999],
        friendship_invitation_id: invitation_two.id
      }
    end

    it "fails at proper step" do
      expect(create_notification.failure[0]).to eq(:check_receivers_existence)
    end

    it "returns proper error message" do
      expect(create_notification.failure[1].first[:message]).to eq(I18n.t("errors.users.not_found"))
    end
  end
end
