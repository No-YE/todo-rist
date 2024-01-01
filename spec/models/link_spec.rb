# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  before do
    allow_any_instance_of(LinkScrapingJob).to receive(:perform).and_return(true)
  end

  describe 'validations' do
    subject { build(:link) }

    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_uniqueness_of(:url).scoped_to(:user_id) }
  end
end
