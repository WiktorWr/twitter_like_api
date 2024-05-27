# frozen_string_literal: true

# == Schema Information
#
# Table name: friendship_invitations
#
#  id          :bigint           not null, primary key
#  status      :enum             default("pending"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  receiver_id :bigint           not null
#  sender_id   :bigint           not null
#
# Indexes
#
#  index_friendship_invitations_on_receiver_id                (receiver_id)
#  index_friendship_invitations_on_sender_id                  (sender_id)
#  index_friendship_invitations_on_sender_id_and_receiver_id  (sender_id,receiver_id) UNIQUE WHERE (status = 'pending'::invitation_status)
#
# Foreign Keys
#
#  fk_rails_...  (receiver_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
FactoryBot.define do
  factory :friendship_invitation do
    sender   { association :user }
    receiver { association :user }
  end
end
