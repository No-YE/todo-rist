# frozen_string_literal: true

class CreateUsersSummarySettings < ActiveRecord::Migration[7.1]
  def change
    create_table :users_summary_settings do |t|
      t.references :user, null: false, foreign_key: false, index: { unique: true }
      t.integer :default_due_days, default: 0
      t.boolean :ai_summarizing_enabled, null: false, default: false
      t.boolean :ai_tagging_enabled, null: false, default: false
      t.timestamps
    end
  end
end
