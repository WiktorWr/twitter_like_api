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

  context "when everything is fine and unread notifications count is cached" do
    let!(:params) do
      {
        notification_type: Notification::NOTIFICATION_TYPES[:post_liked],
        receiver_ids:      [user.id],
        post_id:           post.id
      }
    end

    before do
      RedisStore.current.set("user_#{user.id}_notifications_count", "123")
    end

    it "is success" do
      expect(create_notification).to be_success
    end

    it "creates a notification" do
      expect { create_notification }.to change(Notification, :count).by(1)
    end

    it "assigns a proper post to the notification" do
      create_notification
      expect(Notification.last.post).to eq(post)
    end

    it "assigns a proper notification type to the notification" do
      create_notification
      expect(Notification.last.notification_type).to eq(params[:notification_type])
    end

    it "creates user notifications" do
      expect { create_notification }.to change(UserNotification, :count).by(1)
    end

    it "creates user notifications for proper user" do
      create_notification
      expect(UserNotification.last.user).to eq(user)
    end

    it "increases user unread notifications counter" do
      create_notification
      expect(RedisStore.current.get("user_#{user.id}_notifications_count")).to eq("124")
    end

    it "broadcasts value to the user notifications counter channel" do
      expect { create_notification }.to(
        have_broadcasted_to("user_notifications_counter_channel_#{user.id}").exactly(:once).with(
          { count: "124" }
        )
      )
    end

    it "broadcasts message to the user notifications channel" do
      expect { create_notification }.to(
        have_broadcasted_to("user_notifications_channel_#{user.id}").exactly(:once).with(
          Messages::Representers::Show.one(Message.last)
        )
      )
    end
  end

  context "when everything is fine and unread notifications count is not cached" do
    let!(:params) do
      {
        notification_type:        Notification::NOTIFICATION_TYPES[:friendship_invitation_accepted],
        receiver_ids:             [user.id],
        friendship_invitation_id: invitation_two.id
      }
    end

    before do
      RedisStore.current.flushdb
    end

    it "is success" do
      expect(create_notification).to be_success
    end

    it "creates a notification" do
      expect { create_notification }.to change(Notification, :count).by(1)
    end

    it "assigns a proper friendship invitation to the notification" do
      create_notification
      expect(Notification.last.friendship_invitation).to eq(invitation_two)
    end

    it "assigns a proper notification type to the notification" do
      create_notification
      expect(Notification.last.notification_type).to eq(params[:notification_type])
    end

    it "creates user notifications" do
      expect { create_notification }.to change(UserNotification, :count).by(1)
    end

    it "creates user notifications for proper user" do
      create_notification
      expect(UserNotification.last.user).to eq(user)
    end

    it "creates user unread notifications counter with a proper value" do
      create_notification
      expect(RedisStore.current.get("user_#{user.id}_notifications_count")).to eq("1")
    end

    it "broadcasts value to the user notifications counter channel" do
      expect { create_notification }.to(
        have_broadcasted_to("user_notifications_counter_channel_#{user.id}").exactly(:once).with(
          { count: "1" }
        )
      )
    end

    it "broadcasts message to the user notifications channel" do
      expect { create_notification }.to(
        have_broadcasted_to("user_notifications_channel_#{user.id}").exactly(:once).with(
          Messages::Representers::Show.one(Message.last)
        )
      )
    end
  end
end
