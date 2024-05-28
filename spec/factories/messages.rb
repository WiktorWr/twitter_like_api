# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id           :bigint           not null, primary key
#  text         :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chat_id      :bigint           not null
#  chat_user_id :bigint           not null
#
# Indexes
#
#  index_messages_on_chat_id                      (chat_id)
#  index_messages_on_chat_user_id                 (chat_user_id)
#  index_messages_on_created_at_desc_and_chat_id  (created_at DESC,chat_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_id => chats.id)
#  fk_rails_...  (chat_user_id => chat_users.id)
#
FactoryBot.define do
  factory :message do
    text { Faker::Lorem.paragraph }
    chat
    chat_user
  end
end
