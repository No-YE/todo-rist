# frozen_string_literal: true

ActsAsTaggableOn::Tag.singleton_class.class_eval do
  define_method(:ransackable_attributes) do |_auth_object = nil|
    ['name']
  end
end
