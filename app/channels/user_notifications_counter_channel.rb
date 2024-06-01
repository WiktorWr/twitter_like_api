# frozen_string_literal: true

class UserNotificationsCounterChannel < ApplicationCable::Channel
  def subscribed
    if user_exists?
      stream_from "user_notifications_counter_channel_#{params[:user_id]}"
    else
      reject
    end
  end

  ## HELPER METHODS

  def user_exists?
    User.exists?(id: params[:user_id].to_i)
  end
end