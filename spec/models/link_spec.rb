# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  let_it_be(:link) { create(:link) }
  let_it_be(:user) { create(:user) }

  describe 'validations' do
    subject { build(:link) }

    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_uniqueness_of(:url).scoped_to(:user_id) }
    it do
      is_expected.to validate_comparison_of(:due_date)
        .is_greater_than_or_equal_to(Time.current.to_date)
        .allow_nil
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'callbacks' do
    describe 'after_create_commit' do
      describe '#scrap_later' do
        it 'enqueues a job' do
          expect { create(:link) }.to have_enqueued_job(Links::ScrapingJob)
        end
      end
    end

    describe 'after_update_commit' do
      describe '#broadcast_replace_to' do
        it 'broadcasts to ActionCable' do
          expect { link.update!(title: 'New') }.to have_broadcasted_to(link.to_gid_param).at_least(:once)
        end
      end

      describe '#broadcast_remove_to' do
        it 'broadcasts to ActionCable' do
          expect { link.discard! }.to have_broadcasted_to(link.to_gid_param).at_least(:once)
        end
      end
    end
  end

  describe '#clone' do
    subject { link.clone(user.id) }

    it 'returns a new link' do
      expect(subject).to be_a_new(described_class)
    end

    it 'sets the user_id to the given user_id' do
      expect(subject.user_id).to eq(user.id)
    end

    it 'sets the due_date to nil' do
      expect(subject.due_date).to be_nil
    end

    it 'sets the created_at to nil' do
      expect(subject.created_at).to be_nil
    end
  end

  describe '#read?' do
    subject { link.read? }

    context 'when the link is not read' do
      it { is_expected.to be_falsey }
    end

    context 'when the link is read' do
      before do
        link.read!
      end

      it { is_expected.to be_truthy }
    end
  end

  describe '#unread?' do
    subject { link.unread? }

    context 'when the link is not read' do
      it { is_expected.to be_truthy }
    end

    context 'when the link is read' do
      before do
        link.read!
      end

      it { is_expected.to be_falsey }
    end
  end

  describe '#read!' do
    before { freeze_time }

    it 'sets the read_at to the current time' do
      expect { link.read! }.to change { link.read_at }.from(nil).to(Time.current)
    end
  end

  describe '#unread!' do
    let_it_be(:link) { create(:link, read_at: Time.current) }

    it 'sets the read_at to nil' do
      expect { link.unread! }.to change { link.read_at }.to(nil)
    end
  end

  describe '#must_read?' do
    subject { link.must_read? }

    context 'when the link is read' do
      before do
        link.read!
      end

      it { is_expected.to be_falsey }
    end

    context 'when the link is unread and has a due_date' do
      let_it_be(:link) { create(:link, due_date: Time.current) }

      it { is_expected.to be_truthy }
    end
  end

  describe '#to_remind_info' do
    subject { link.to_remind_info }

    it { is_expected.to be_a(Links::RemindInfo) }
  end

  describe '#scrap_now' do
    it 'calls the Links::ScrapingJob' do
      expect_any_instance_of(Links::ScrapingJob).to receive(:perform_now)
      link.scrap_now
    end
  end
end
