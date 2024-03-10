# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = 'https://3d2e4fbb1c02800b099da5c201e82cb2@o4506494294491136.ingest.us.sentry.io/4506494294622208'
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  config.enabled_environments = %w[production]
end
