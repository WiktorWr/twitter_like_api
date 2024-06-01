# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id                       :bigint           not null, primary key
#  notification_type        :enum             not null
#  text                     :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  friendship_invitation_id :bigint
#  post_id                  :bigint
#
# Indexes
#
#  index_notifications_on_friendship_invitation_id  (friendship_invitation_id)
#  index_notifications_on_post_id                   (post_id)
#
# Foreign Keys
#
#  fk_rails_...  (friendship_invitation_id => friendship_invitations.id)
#  fk_rails_...  (post_id => posts.id)
#
class Notification < ApplicationRecord
  belongs_to :friendship_invitation, optional: true
  belongs_to :post, optional: true

  NOTIFICATION_TYPES = {
    friendship_invitation: "friendship_invitation",
    post_liked:            "post_liked"
  }.freeze

  enum notification_type: NOTIFICATION_TYPES
end
