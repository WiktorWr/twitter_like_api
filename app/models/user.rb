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
class User < ApplicationRecord
  has_secure_password

  has_many :posts, dependent: :destroy

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, source: :friend

  # rubocop:disable Rails/InverseOf
  has_many :access_grants,
           class_name:  "Doorkeeper::AccessGrant",
           foreign_key: :resource_owner_id,
           dependent:   :delete_all

  has_many :access_tokens,
           class_name:  "Doorkeeper::AccessToken",
           foreign_key: :resource_owner_id,
           dependent:   :delete_all
  # rubocop:enable Rails/InverseOf
end
