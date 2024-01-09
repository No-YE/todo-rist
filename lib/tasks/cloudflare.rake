# frozen_string_literal: true

namespace :cloudflare do
  desc 'Setup CORS for Cloudflare'
  task setup: :environment do
    bucket = ActiveStorage::Blob.service.bucket
    bucket.cors.put(
      cors_configuration: {
        cors_rules: [
          {
            allowed_headers: ['*'],
            allowed_methods: ['PUT'],
            allowed_origins: ['*'], # replace with app host with https for production
            expose_headers: %w[Origin Content-Type Content-MD5 Content-Disposition],
            max_age_seconds: 3600,
          },
        ],
      },
    )
  end
end
