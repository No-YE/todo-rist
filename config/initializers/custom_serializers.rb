# frozen_string_literal: true

Rails.autoloaders.main.ignore("#{Rails.root}/app/serializers")

require_relative '../../app/serializers/links/remind_info_serializer'
Rails.application.config.active_job.custom_serializers << Links::RemindInfoSerializer
