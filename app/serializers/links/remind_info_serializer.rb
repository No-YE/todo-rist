# frozen_string_literal: true

module Links
  class RemindInfoSerializer < ActiveJob::Serializers::ObjectSerializer
    def serialize?(argument)
      argument.is_a? Links::RemindInfo
    end

    def serialize(remind_info)
      super(remind_info.as_json)
    end

    def deserialize(hash)
      Links::RemindInfo.new(
        id: hash['id'],
        title: hash['title'],
        summary: hash['summary'],
        due_date: hash['due_date'],
        url: hash['url'],
        created_at: hash['created_at'],
      )
    end
  end
end
