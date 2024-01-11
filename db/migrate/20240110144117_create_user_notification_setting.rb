# frozen_string_literal: true

class CreateUserNotificationSetting < ActiveRecord::Migration[7.1]
  def change
    create_table :users_notification_settings do |t|
      t.references :user, null: false, foreign_key: false, index: { unique: true }
      t.boolean :email, null: false, default: false
      t.integer :schedule_days, array: true, null: false, default: []
      t.time :schedule_time, null: false
      t.timestamps
    end
  end
end
