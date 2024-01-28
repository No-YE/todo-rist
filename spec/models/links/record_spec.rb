# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Links::Record, type: :model do
  describe 'validations' do
    subject { create(:links_record) }

    it { is_expected.to validate_presence_of(:link) }
    it { is_expected.to validate_uniqueness_of(:link) }
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:link) }
  end
end
