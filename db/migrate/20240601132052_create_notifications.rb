# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_enum "notification_type", %w[friendship_invitation post_liked]

    create_table :notifications do |t|
      t.string :text, null: false
      t.references :friendship_invitation, foreign_key: true, null: true
      t.references :post, foreign_key: true, null: true
      t.enum :notification_type, enum_type: :notification_type, null: false

      t.timestamps
    end
  end
end
