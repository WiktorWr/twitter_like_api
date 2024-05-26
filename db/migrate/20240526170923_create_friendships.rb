# frozen_string_literal: true

class CreateFriendships < ActiveRecord::Migration[7.1]
  def change
    create_table :friendships do |t|
      t.references :user, foreign_key: true, null: false
      t.references :friend, foreign_key: { to_table: :users }, null: false

      t.timestamps
    end

    add_index :friendships, [:user_id, :friend_id], unique: true
    add_check_constraint :friendships, "user_id <> friend_id", name: "user_id_not_equal_to_friend_id"
  end
end
