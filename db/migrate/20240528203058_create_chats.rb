# frozen_string_literal: true

class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats, &:timestamps
  end
end
