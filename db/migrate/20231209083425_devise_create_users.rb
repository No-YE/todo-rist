# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      ## Omniauthable
      t.string :email, null: false
      t.string :encrypted_password, null: false, default: ''
      t.string :name, null: false
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :image

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.boolean :admin, default: false, null: false

      t.datetime :discarded_at, index: true
      t.timestamps null: false
    end

    add_index :users, :email, unique: true, where: 'discarded_at IS NULL'
    add_index :users, %i[provider uid], unique: true, where: 'discarded_at IS NULL'
  end
end
