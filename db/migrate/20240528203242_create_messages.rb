# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.text :text, null: false
      t.references :chat, foreign_key: true, null: false
      t.references :chat_user, foreign_key: true, null: false

      t.timestamps
    end

    add_index :messages,
              %i(created_at chat_id),
              order: { created_at: :desc },
              name:  "index_messages_on_created_at_desc_and_chat_id"
  end
end
