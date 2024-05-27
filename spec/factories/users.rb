# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                              :bigint           not null, primary key
#  email                           :string           not null
#  first_name                      :string           not null
#  last_name                       :string           not null
#  password_digest                 :string           not null
#  reset_password_token            :string
#  reset_password_token_created_at :datetime
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    first_name                      { Faker::Name.first_name }
    last_name                       { Faker::Name.last_name }
    email                           { Faker::Internet.unique.email }
    password                        { Faker::Internet.password }
  end
end
