# frozen_string_literal: true

module Link::Searchable
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(_auth_object = nil)
      super
    end
  end
end
