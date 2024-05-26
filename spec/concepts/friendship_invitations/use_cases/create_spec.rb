# frozen_string_literal: true

describe FriendshipInvitations::UseCases::Create do
  subject(:create_friendship_invitation) { described_class.new(params, user).call }

  let!(:user)       { create(:user) }
  let!(:other_user) { create(:user) }

  context "when params are missing" do
    let(:params) { {} }

    it_behaves_like "schema validation failure",
                    [
                      "receiver_id is missing"
                    ]
  end

  context "when params are invalid" do
    let(:params) do
      {
        receiver_id: -1
      }
    end

    it_behaves_like "schema validation failure",
                    [
                      "receiver_id must be greater than 0"
                    ]
  end

  context "when receiver is not found" do
    let(:params) do
      {
        receiver_id: 999_999_999
      }
    end

    it "fails at proper step" do
      expect(create_friendship_invitation.failure[0]).to eq(:check_receiver_existence)
    end

    it "returns proper error message" do
      expect(create_friendship_invitation.failure[1].first[:message]).to eq(I18n.t("errors.users.not_found"))
    end
  end

  context "when receiver is user" do
    let(:params) do
      {
        receiver_id: user.id
      }
    end

    it "fails at proper step" do
      expect(create_friendship_invitation.failure[0]).to eq(:check_if_receiver_is_not_sender)
    end

    it "returns proper error message" do
      expect(create_friendship_invitation.failure[1].first[:message]).to eq(I18n.t("errors.friendship_invitations.receiver_is_sender"))
    end
  end

  context "when users are friends" do
    let(:params) do
      {
        receiver_id: other_user.id
      }
    end

    before do
      create(:friendship, user:, friend: other_user)
      create(:friendship, user: other_user, friend: user)
    end

    it "fails at proper step" do
      expect(create_friendship_invitation.failure[0]).to eq(:check_if_users_are_friends)
    end

    it "returns proper error message" do
      expect(create_friendship_invitation.failure[1].first[:message]).to eq(I18n.t("errors.friendship_invitations.users_are_friends"))
    end
  end

  context "when peding invitation exists" do
    let(:params) do
      {
        receiver_id: other_user.id
      }
    end

    before do
      create(:friendship_invitation, sender: user, receiver: other_user)
    end

    it "fails at proper step" do
      expect(create_friendship_invitation.failure[0]).to eq(:check_pending_invitation_existence)
    end

    it "returns proper error message" do
      expect(create_friendship_invitation.failure[1].first[:message]).to eq(I18n.t("errors.friendship_invitations.pending_invitation_exists"))
    end
  end

  context "when peding invitation exists (receiver sent invitation)" do
    let(:params) do
      {
        receiver_id: other_user.id
      }
    end

    before do
      create(:friendship_invitation, sender: other_user, receiver: user)
    end

    it "fails at proper step" do
      expect(create_friendship_invitation.failure[0]).to eq(:check_pending_invitation_existence)
    end

    it "returns proper error message" do
      expect(create_friendship_invitation.failure[1].first[:message]).to eq(I18n.t("errors.friendship_invitations.pending_invitation_exists"))
    end
  end

  context "when everything is fine and no previous invitations exist" do
    let(:params) do
      {
        receiver_id: other_user.id
      }
    end

    it "is success" do
      expect(create_friendship_invitation).to be_success
    end

    it "creates a new friendship invitation" do
      expect { create_friendship_invitation }.to change(FriendshipInvitation, :count).by(1)
    end

    it "sets propoer friendship invitation status" do
      expect(create_friendship_invitation.success.invitation_status).to eq(FriendshipInvitation::INVIATION_STATUSES[:pending])
    end
  end

  context "when everything is fine and there are previous rejected invitations" do
    let(:params) do
      {
        receiver_id: other_user.id
      }
    end

    before do
      create(:friendship_invitation, sender: other_user, receiver: user, invitation_status: FriendshipInvitation::INVIATION_STATUSES[:rejected])
    end

    it "is success" do
      expect(create_friendship_invitation).to be_success
    end

    it "creates a new friendship invitation" do
      expect { create_friendship_invitation }.to change(FriendshipInvitation, :count).by(1)
    end

    it "sets propoer friendship invitation status" do
      expect(create_friendship_invitation.success.invitation_status).to eq(FriendshipInvitation::INVIATION_STATUSES[:pending])
    end
  end
end
