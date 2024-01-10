# frozen_string_literal: true

class AddLocaleToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :locale, :string, default: 'ko', null: false
  end
end
