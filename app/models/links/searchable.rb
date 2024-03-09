# frozen_string_literal: true

module Links::Searchable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(_auth_object = nil)
      %w[title read_at]
    end

    def ransortable_attributes(_auth_object = nil)
      %w[id due_date]
    end

    def ransackable_associations(_auth_object = nil)
      %w[tags]
    end
  end
end
