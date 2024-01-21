# frozen_string_literal: true

class CreateLinksRecord < ActiveRecord::Migration[7.1]
  def change
    create_table :links_records do |t|
      t.references :link, null: false, foreign_key: false, index: { unique: true }
      t.text :content, null: false

      t.datetime :discarded_at, index: true
      t.timestamps null: false
    end
  end
end
