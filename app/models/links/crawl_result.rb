# frozen_string_literal: true

class Links::CrawlResult
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :image_url, :string
  attribute :outline, :string
end
