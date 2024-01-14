# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :recipient, polymorphic: true, null: false, index: true
      t.string :type, null: false
      t.jsonb :params
      t.datetime :read_at, index: true

      t.timestamps
    end
  end
end
