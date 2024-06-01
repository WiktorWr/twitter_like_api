# frozen_string_literal: true

# == Schema Information
#
# Table name: user_notifications
#
#  id              :bigint           not null, primary key
#  seen            :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notification_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_user_notifications_on_notification_id              (notification_id)
#  index_user_notifications_on_user_id                      (user_id)
#  index_user_notifications_on_user_id_and_notification_id  (user_id,notification_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (notification_id => notifications.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :user_notification do
    user
    notification
  end
end
