# frozen_string_literal: true

class Links::Record < Links::ApplicationRecord
  belongs_to :link

  validates :link, presence: true, uniqueness: true
  validates :content, presence: true
end
