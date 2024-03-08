# frozen_string_literal: true

class Links::Record < Links::ApplicationRecord
  include Discard::Model

  belongs_to :link

  validates :link, uniqueness: true
  validates :content, presence: true
end
