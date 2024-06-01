# frozen_string_literal: true

class ChatChannel < ApplicationCable::Channel
  def subscribed
    if chat_user_valid?
      stream_from "chat_channel_#{params[:chat_id]}"
    else
      reject
    end
  end

  # HELPER METHODS

  def chat_user_valid?
    ChatUser.exists?(chat_id: params[:chat_id].to_i, user_id: connection.current_user.id)
  end
end
