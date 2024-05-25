# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.text :text, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
