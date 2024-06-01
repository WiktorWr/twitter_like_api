# frozen_string_literal: true

class CreateUserNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :user_notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notification, null: false, foreign_key: true
      t.boolean :seen, null: false, default: false

      t.timestamps

      t.index %i[user_id notification_id], unique: true
    end
  end
end
