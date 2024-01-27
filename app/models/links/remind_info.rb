# frozen_string_literal: true

class Links::RemindInfo
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Serializers::JSON

  attribute :id, :integer
  attribute :title, :string
  attribute :summary, :string
  attribute :due_date, :date
  attribute :url, :string
  attribute :created_at, :datetime

  def attributes
    {
      'id' => nil,
      'title' => nil,
      'summary' => nil,
      'due_date' => nil,
      'url' => nil,
      'created_at' => nil,
    }
  end
end
