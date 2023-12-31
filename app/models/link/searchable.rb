# frozen_string_literal: true

module Link::Searchable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(_auth_object = nil)
      %w[title read_at]
    end

    def ransortable_attributes(_auth_object = nil)
      %w[id due_date]
    end
  end
end
