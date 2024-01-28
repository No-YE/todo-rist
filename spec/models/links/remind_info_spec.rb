# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Links::RemindInfo, type: :model do
  subject { build_stubbed(:link).to_remind_info }

  describe '#attributes' do
    it 'returns the attributes' do
      expect(subject.attributes.keys)
        .to contain_exactly('id', 'title', 'summary', 'due_date', 'url', 'created_at')
    end
  end
end
