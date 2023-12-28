# frozen_string_literal: true

class Init < ActiveRecord::Migration[7.1]
  # for Devise
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

    # for GoodJob
    create_table :good_jobs, id: :uuid do |t|
      t.text :queue_name
      t.integer :priority
      t.jsonb :serialized_params
      t.datetime :scheduled_at
      t.datetime :performed_at
      t.datetime :finished_at
      t.text :error

      t.timestamps

      t.uuid :active_job_id
      t.text :concurrency_key
      t.text :cron_key
      t.uuid :retried_good_job_id
      t.datetime :cron_at

      t.uuid :batch_id
      t.uuid :batch_callback_id

      t.boolean :is_discrete
      t.integer :executions_count
      t.text :job_class
      t.integer :error_event, limit: 2
    end

    create_table :good_job_batches, id: :uuid do |t|
      t.timestamps
      t.text :description
      t.jsonb :serialized_properties
      t.text :on_finish
      t.text :on_success
      t.text :on_discard
      t.text :callback_queue_name
      t.integer :callback_priority
      t.datetime :enqueued_at
      t.datetime :discarded_at
      t.datetime :finished_at
    end

    create_table :good_job_executions, id: :uuid do |t|
      t.timestamps

      t.uuid :active_job_id, null: false
      t.text :job_class
      t.text :queue_name
      t.jsonb :serialized_params
      t.datetime :scheduled_at
      t.datetime :finished_at
      t.text :error
      t.integer :error_event, limit: 2
    end

    create_table :good_job_processes, id: :uuid do |t|
      t.timestamps
      t.jsonb :state
    end

    create_table :good_job_settings, id: :uuid do |t|
      t.timestamps
      t.text :key
      t.jsonb :value
      t.index :key, unique: true
    end

    add_index :good_jobs, :scheduled_at, where: '(finished_at IS NULL)', name: :index_good_jobs_on_scheduled_at
    add_index :good_jobs, %i[queue_name scheduled_at], where: '(finished_at IS NULL)',
              name: :index_good_jobs_on_queue_name_and_scheduled_at
    add_index :good_jobs, %i[active_job_id created_at], name: :index_good_jobs_on_active_job_id_and_created_at
    add_index :good_jobs, :concurrency_key, where: '(finished_at IS NULL)',
              name: :index_good_jobs_on_concurrency_key_when_unfinished
    add_index :good_jobs, %i[cron_key created_at], where: '(cron_key IS NOT NULL)',
              name: :index_good_jobs_on_cron_key_and_created_at_cond
    add_index :good_jobs, %i[cron_key cron_at], where: '(cron_key IS NOT NULL)', unique: true,
              name: :index_good_jobs_on_cron_key_and_cron_at_cond
    add_index :good_jobs, [:active_job_id], name: :index_good_jobs_on_active_job_id
    add_index :good_jobs, [:finished_at], where: 'retried_good_job_id IS NULL AND finished_at IS NOT NULL',
              name: :index_good_jobs_jobs_on_finished_at
    add_index :good_jobs, %i[priority created_at], order: { priority: 'DESC NULLS LAST', created_at: :asc },
              where: 'finished_at IS NULL', name: :index_good_jobs_jobs_on_priority_created_at_when_unfinished
    add_index :good_jobs, [:batch_id], where: 'batch_id IS NOT NULL'
    add_index :good_jobs, [:batch_callback_id], where: 'batch_callback_id IS NOT NULL'

    add_index :good_job_executions, %i[active_job_id created_at],
              name: :index_good_job_executions_on_active_job_id_and_created_at

    # for Motor admin
    create_table :motor_queries do |t|
      t.column :name, :string, null: false
      t.column :description, :text
      t.column :sql_body, :text, null: false
      t.column :preferences, :text, null: false
      t.column :author_id, :bigint
      t.column :author_type, :string
      t.column :deleted_at, :datetime

      t.timestamps

      t.index :updated_at
      t.index 'name',
              name: 'motor_queries_name_unique_index',
              unique: true,
              where: 'deleted_at IS NULL'
    end

    create_table :motor_dashboards do |t|
      t.column :title, :string, null: false
      t.column :description, :text
      t.column :preferences, :text, null: false
      t.column :author_id, :bigint
      t.column :author_type, :string
      t.column :deleted_at, :datetime

      t.timestamps

      t.index :updated_at
      t.index 'title',
              name: 'motor_dashboards_title_unique_index',
              unique: true,
              where: 'deleted_at IS NULL'
    end

    create_table :motor_forms do |t|
      t.column :name, :string, null: false
      t.column :description, :text
      t.column :api_path, :text, null: false
      t.column :http_method, :string, null: false
      t.column :preferences, :text, null: false
      t.column :author_id, :bigint
      t.column :author_type, :string
      t.column :deleted_at, :datetime
      t.column :api_config_name, :string, null: false

      t.timestamps

      t.index :updated_at
      t.index 'name',
              name: 'motor_forms_name_unique_index',
              unique: true,
              where: 'deleted_at IS NULL'
    end

    create_table :motor_resources do |t|
      t.column :name, :string, null: false, index: { unique: true }
      t.column :preferences, :text, null: false

      t.timestamps

      t.index :updated_at
    end

    create_table :motor_configs do |t|
      t.column :key, :string, null: false, index: { unique: true }
      t.column :value, :text, null: false

      t.timestamps

      t.index :updated_at
    end

    create_table :motor_alerts do |t|
      t.references :query, null: false, foreign_key: { to_table: :motor_queries }, index: true
      t.column :name, :string, null: false
      t.column :description, :text
      t.column :to_emails, :text, null: false
      t.column :is_enabled, :boolean, null: false, default: true
      t.column :preferences, :text, null: false
      t.column :author_id, :bigint
      t.column :author_type, :string
      t.column :deleted_at, :datetime

      t.timestamps

      t.index :updated_at
      t.index 'name',
              name: 'motor_alerts_name_unique_index',
              unique: true,
              where: 'deleted_at IS NULL'
    end

    create_table :motor_alert_locks do |t|
      t.references :alert, null: false, foreign_key: { to_table: :motor_alerts }
      t.column :lock_timestamp, :string, null: false

      t.timestamps

      t.index %i[alert_id lock_timestamp], unique: true
    end

    create_table :motor_tags do |t|
      t.column :name, :string, null: false

      t.timestamps

      t.index 'name',
              name: 'motor_tags_name_unique_index',
              unique: true
    end

    create_table :motor_taggable_tags do |t|
      t.references :tag, null: false, foreign_key: { to_table: :motor_tags }, index: true
      t.column :taggable_id, :bigint, null: false
      t.column :taggable_type, :string, null: false

      t.index %i[taggable_id taggable_type tag_id],
              name: 'motor_polymorphic_association_tag_index',
              unique: true
    end

    create_table :motor_audits do |t|
      t.column :auditable_id, :string
      t.column :auditable_type, :string
      t.column :associated_id, :string
      t.column :associated_type, :string
      t.column :user_id, :bigint
      t.column :user_type, :string
      t.column :username, :string
      t.column :action, :string
      t.column :audited_changes, :text
      t.column :version, :bigint, default: 0
      t.column :comment, :text
      t.column :remote_address, :string
      t.column :request_uuid, :string
      t.column :created_at, :datetime
    end

    create_table :motor_api_configs do |t|
      t.column :name, :string, null: false
      t.column :url, :string, null: false
      t.column :preferences, :text, null: false
      t.column :credentials, :text, null: false
      t.column :description, :text
      t.column :deleted_at, :datetime

      t.timestamps

      t.index 'name',
              name: 'motor_api_configs_name_unique_index',
              unique: true,
              where: 'deleted_at IS NULL'
    end

    create_table :motor_notes do |t|
      t.column :body, :text
      t.column :author_id, :bigint
      t.column :author_type, :string
      t.column :record_id, :string, null: false
      t.column :record_type, :string, null: false
      t.column :deleted_at, :datetime

      t.timestamps

      t.index %i[record_id record_type],
              name: 'motor_notes_record_id_record_type_index'

      t.index %i[author_id author_type],
              name: 'motor_notes_author_id_author_type_index'
    end

    create_table :motor_note_tags do |t|
      t.column :name, :string, null: false

      t.timestamps

      t.index 'name',
              name: 'motor_note_tags_name_unique_index',
              unique: true
    end

    create_table :motor_note_tag_tags do |t|
      t.references :tag, null: false, foreign_key: { to_table: :motor_note_tags }, index: true
      t.references :note, null: false, foreign_key: { to_table: :motor_notes }, index: false

      t.index %i[note_id tag_id],
              name: 'motor_note_tags_note_id_tag_id_index',
              unique: true
    end

    create_table :motor_reminders do |t|
      t.column :author_id, :bigint, null: false
      t.column :author_type, :string, null: false
      t.column :recipient_id, :bigint, null: false
      t.column :recipient_type, :string, null: false
      t.column :record_id, :string
      t.column :record_type, :string
      t.column :scheduled_at, :datetime, null: false, index: true

      t.timestamps

      t.index %i[author_id author_type],
              name: 'motor_reminders_author_id_author_type_index'

      t.index %i[recipient_id recipient_type],
              name: 'motor_reminders_recipient_id_recipient_type_index'

      t.index %i[record_id record_type],
              name: 'motor_reminders_record_id_record_type_index'
    end

    create_table :motor_notifications do |t|
      t.column :title, :string, null: false
      t.column :description, :text
      t.column :recipient_id, :bigint, null: false
      t.column :recipient_type, :string, null: false
      t.column :record_id, :string
      t.column :record_type, :string
      t.column :status, :string, null: false

      t.timestamps

      t.index %i[recipient_id recipient_type],
              name: 'motor_notifications_recipient_id_recipient_type_index'

      t.index %i[record_id record_type],
              name: 'motor_notifications_record_id_record_type_index'
    end

    add_index :motor_audits, %i[auditable_type auditable_id version], name: 'motor_auditable_index'
    add_index :motor_audits, %i[associated_type associated_id], name: 'motor_auditable_associated_index'
    add_index :motor_audits, %i[user_id user_type], name: 'motor_auditable_user_index'
    add_index :motor_audits, :request_uuid
    add_index :motor_audits, :created_at

    model = Class.new(ApplicationRecord)

    model.table_name = 'motor_configs'

    model.create!(key: 'header.links', value: [{
                                                 name: '⭐ Star on GitHub',
                                                 path: 'https://github.com/motor-admin/motor-admin-rails'
                                               }].to_json)

    model.table_name = 'motor_api_configs'

    model.create!(name: 'origin', url: '/', preferences: {}, credentials: {})

    # for model

    create_table :links do |t|
      t.string :title
      t.text :summary
      t.string :image_url
      t.string :url, null: false
      t.string :sanitized_url, null: false, index: { where: 'discarded_at IS NULL' }
      t.integer :scraping_state, null: false, default: 0
      t.belongs_to :user, null: false, foreign_key: false

      t.datetime :discarded_at, index: true
      t.timestamps null: false
    end
  end
end

