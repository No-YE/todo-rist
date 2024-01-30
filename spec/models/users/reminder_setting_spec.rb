# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::ReminderSetting, type: :model do
  let(:reminder_setting) { create(:users_reminder_setting, schedule_days: %w[monday]) }

  describe 'validations' do
    subject { build(:users_reminder_setting) }

    it { is_expected.to validate_presence_of(:criteria_days) }
    it {
      is_expected
        .to validate_numericality_of(:criteria_days).only_integer.is_greater_than_or_equal_to(1)
    }
    it { is_expected.to validate_presence_of(:email) }
    it {
      is_expected
        .to validate_inclusion_of(:schedule_days)
        .in_array(%w[sunday monday tuesday wednesday thursday friday saturday])
    }
    it { is_expected.to validate_presence_of(:schedule_time) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'callbacks' do
    describe 'before_validation' do
      describe '#downcase_schedule_days' do
        let(:reminder_setting) { build(:users_reminder_setting, schedule_days: %w[Monday]) }

        it 'downcases the schedule_days' do
          expect { reminder_setting.valid? }
            .to change { reminder_setting.schedule_days }.to(%w[monday])
        end
      end
    end

    describe 'after_create_commit' do
      context 'when schedule_days is changed' do
        it 'call schedule_job method' do
          expect(reminder_setting).to receive(:schedule_job)
          reminder_setting.update!(schedule_days: %w[tuesday])
        end
      end

      context 'when schedule_days is not changed' do
        it 'does not call schedule_job method' do
          expect(reminder_setting).not_to receive(:schedule_job)
          reminder_setting.update!(criteria_days: 2)
        end
      end
    end
  end

  describe '#schedule_job' do
    before do
      allow(GoodJob::Job).to receive(:where).and_return(ActiveRecord::Relation.new(GoodJob::Job))
      allow(Links::RemindJob).to receive(:set).and_return(Links::RemindJob)
    end

    context 'when next_remind_job_id is present' do
      it 'destroys the job' do
        expect(GoodJob::Job).to receive(:where).with(id: reminder_setting.next_remind_job_id)
        reminder_setting.schedule_job
      end
    end

    context 'when next_occuring is present' do
      it 'creates a new job' do
        expect(Links::RemindJob).to receive(:set).with(wait_until: reminder_setting.schedule.next_occurring)
        reminder_setting.schedule_job
        expect(reminder_setting.next_remind_job_id).not_to be_nil
      end
    end
  end
end
