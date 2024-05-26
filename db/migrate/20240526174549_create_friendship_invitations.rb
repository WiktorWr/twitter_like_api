# frozen_string_literal: true

class CreateFriendshipInvitations < ActiveRecord::Migration[7.1]
  def change
    create_enum "invitation_status", %w[pending accepted rejected]

    create_table :friendship_invitations do |t|
      t.references :sender, foreign_key: { to_table: :users }, null: false
      t.references :receiver, foreign_key: { to_table: :users }, null: false
      t.enum :invitation_status, enum_type: :invitation_status, null: false, default: "pending"

      t.timestamps
    end

    add_index :friendship_invitations, [:sender_id, :receiver_id], unique: true, where: "invitation_status = 'pending'"
    add_check_constraint :friendship_invitations, "sender_id <> receiver_id", name: "sender_not_equal_to_receiver"
  end
end
