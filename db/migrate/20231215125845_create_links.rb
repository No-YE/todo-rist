# frozen_string_literal: true

class CreateLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :links do |t|
      t.string :title
      t.text :summary
      t.string :url, null: false
      t.string :sanitized_url, null: false, index: { where: 'discarded_at IS NULL' }
      t.integer :status, null: false, default: 0, unsigned: true
      t.belongs_to :user, null: false, foreign_key: false

      t.datetime :discarded_at, index: true
      t.timestamps null: false
    end
  end
end
