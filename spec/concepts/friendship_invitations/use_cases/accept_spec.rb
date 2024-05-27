# frozen_string_literal: true

describe FriendshipInvitations::UseCases::Accept do
  subject(:accept_friendship_invitation) { described_class.new(params, user).call }

  let!(:user)       { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:invitation) { create(:friendship_invitation, sender: other_user, receiver: user) }

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

  context "when invitation is not found" do
    let(:params) do
      {
        id: 999_999_999
      }
    end

    it "fails at proper step" do
      expect(accept_friendship_invitation.failure[0]).to eq(:check_invitation_existence)
    end

    it "returns proper error message" do
      expect(accept_friendship_invitation.failure[1].first[:message]).to eq(I18n.t("errors.friendship_invitations.not_found"))
    end
  end

  context "when user is not invitation receiver" do
    let(:params) do
      {
        id: invitation.id
      }
    end

    let!(:invitation) { create(:friendship_invitation, sender: user, receiver: other_user) }

    it "fails at proper step" do
      expect(accept_friendship_invitation.failure[0]).to eq(:authorize)
    end

    it "returns proper error message" do
      expect(accept_friendship_invitation.failure[1].first[:message]).to eq(I18n.t("errors.common.access_forbidden"))
    end
  end

  context "when invitation is already accepted" do
    let(:params) do
      {
        id: invitation.id
      }
    end

    before do
      invitation.accept
    end

    it "fails at proper step" do
      expect(accept_friendship_invitation.failure[0]).to eq(:check_invitation_status)
    end

    it "returns proper error message" do
      expect(accept_friendship_invitation.failure[1].first[:message]).to eq(I18n.t("errors.friendship_invitations.not_pending"))
    end
  end

  context "when invitation is already rejected" do
    let(:params) do
      {
        id: invitation.id
      }
    end

    before do
      invitation.reject
    end

    it "fails at proper step" do
      expect(accept_friendship_invitation.failure[0]).to eq(:check_invitation_status)
    end

    it "returns proper error message" do
      expect(accept_friendship_invitation.failure[1].first[:message]).to eq(I18n.t("errors.friendship_invitations.not_pending"))
    end
  end

  context "when everything is fine" do
    let(:params) do
      {
        id: invitation.id
      }
    end

    it "is success" do
      expect(accept_friendship_invitation).to be_success
    end

    it "updates invitation status to accepted" do
      expect { accept_friendship_invitation }.to(change { invitation.reload.status }.to(FriendshipInvitation::STATUSES[:accepted]))
    end

    it "creates friendships" do
      expect { accept_friendship_invitation }.to change(Friendship, :count).by(2)
    end

    it "adds sender to receiver's friends" do
      accept_friendship_invitation
      expect(invitation.receiver.reload.friends).to contain_exactly(invitation.sender)
    end

    it "adds receiver to sender's friends" do
      accept_friendship_invitation
      expect(invitation.sender.reload.friends).to contain_exactly(invitation.receiver)
    end
  end
end
