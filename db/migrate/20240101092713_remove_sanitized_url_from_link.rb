class RemoveSanitizedUrlFromLink < ActiveRecord::Migration[7.1]
  def change
    remove_column :links, :sanitized_url, :string
  end
end
