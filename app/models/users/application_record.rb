# frozen_string_literal: true

class Users::ApplicationRecord < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'users_'
end
