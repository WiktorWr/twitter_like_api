# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id          :bigint           not null, primary key
#  likes_count :integer          default(0), not null
#  text        :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :post do
    text { Faker::Lorem.paragraph }
    user
  end
end
