# frozen_string_literal: true

class Links::ApplicationRecord < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'links_'
end
