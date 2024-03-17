# frozen_string_literal: true

module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings, class_name: 'Tag'
    after_save :update_tags
  end

  def tag_names
    if instance_variable_defined?(:@tag_names)
      instance_variable_get(:@tag_names)
    else
      tags.map(&:name)
    end
  end

  def tag_names=(names)
    instance_variable_set(:@tag_names, names)
  end

  private

  def update_tags
    return unless instance_variable_defined?(:@tag_names)

    @tag_names.compact_blank!

    current_tag_names = tags.where(user:).pluck(:name)
    new_tag_names = @tag_names - current_tag_names
    old_tag_names = current_tag_names - @tag_names

    tag_class = self.class.reflect_on_association(:tags).klass

    # rubocop:disable Rails/SkipsModelValidations
    Tag.insert_all(
      new_tag_names.map { |name| { name:, user_id:, type: tag_class.name } },
      unique_by: %i[user_id type name],
    )
    # rubocop:enable Rails/SkipsModelValidations

    tags << tag_class.where(name: new_tag_names, user:)
    taggings.joins(:tag).where(tags: { name: old_tag_names }).destroy_all
  end
end
