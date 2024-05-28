# frozen_string_literal: true

# == Schema Information
#
# Table name: chats
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Chat < ApplicationRecord
  has_many :chat_users, dependent: :destroy
  has_many :messages, dependent: :destroy
end
