class RemoveActsAsTaggableOn < ActiveRecord::Migration[7.1]
  def change
    reversible do |dir|
      dir.up do
        drop_table :tags, force: :cascade, if_exists: true
        drop_table :taggings, force: :cascade, if_exists: true
      end

      dir.down {}
    end

    create_table :tags do |t|
      t.string :name, null: false
      t.string :type, null: false
      t.integer :taggings_count, default: 0
      t.references :user, null: false
      t.timestamps
      t.index %i[user_id type name], unique: true
    end

    create_table :taggings do |t|
      t.references :tag, null: false, index: true
      t.references :taggable, polymorphic: true, index: true, null: false
      t.datetime :created_at
      t.index %i[tag_id taggable_type taggable_id], unique: true
      t.index %i[taggable_type taggable_id]
    end
  end
end
