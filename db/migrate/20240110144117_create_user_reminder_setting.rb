# frozen_string_literal: true

class CreateUserReminderSetting < ActiveRecord::Migration[7.1]
  def change
    create_table :users_reminder_settings do |t|
      t.references :user, null: false, foreign_key: false, index: { unique: true }
      t.integer :criteria_days, null: false, default: 0
      t.boolean :email, null: false, default: false
      t.integer :schedule_days, array: true, null: false, default: []
      t.time :schedule_time, null: false
      t.timestamps
    end
  end
end
