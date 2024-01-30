# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::ReminderSetting, type: :model do
  let(:reminder_setting) { create(:users_reminder_setting, schedule_days: %w[monday]) }

  describe 'validations' do
    subject { build(:users_reminder_setting) }

    it { is_expected.to validate_presence_of(:criteria_days) }
    it {
      is_expected
        .to validate_numericality_of(:criteria_days).only_integer.is_greater_than_or_equal_to(0)
    }
    it { is_expected.to validate_presence_of(:email) }

    it '', pending: 'shoulda-matchers does not support inclusion validation with array attribute' do
      is_expected
        .to validate_inclusion_of(:schedule_days)
        .in_array(%w[sunday monday tuesday wednesday thursday friday saturday])
    end
    it { is_expected.to validate_presence_of(:schedule_time) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'callbacks' do
    describe 'before_validation' do
      describe '#downcase_schedule_days' do
        it 'reject blank schedule_days' do
          reminder_setting.schedule_days << ''
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
    context 'when next_remind_job_id is present' do
      it 'destroys existing job' do
        allow(GoodJob::Job).to receive(:where).and_return(ActiveRecord::Relation.new(GoodJob::Job))

        expect(GoodJob::Job).to receive(:where).with(id: reminder_setting.next_remind_job_id)
        reminder_setting.schedule_job
      end
    end

    context 'when schedule_days is not present' do
      it 'does not create a job' do
        reminder_setting.update!(schedule_days: [])
        expect { reminder_setting.reload.schedule_job }.not_to have_enqueued_job(Links::RemindJob)
      end
    end

    context 'when schedule_days is present' do
      before { travel_to Time.zone.parse('2023-01-01 9:00') }
      after { travel_back }

      where(:schedule_days, :schedule_time, :next_occurring) do
        [
          [%w[monday saturday], '9am', Time.zone.parse('2023-01-02 9:00')],
          [%w[sunday monday], '10am', Time.zone.parse('2023-01-01 10:00')],
          [%w[sunday], '8am', Time.zone.parse('2023-01-08 8:00')],
          [%w[sunday], '9am', Time.zone.parse('2023-01-08 9:00')],
        ]
      end

      with_them do
        it 'create a job at right time' do
          reminder_setting.update!(schedule_days:, schedule_time:)
          expect { reminder_setting.reload.schedule_job }
            .to have_enqueued_job(Links::RemindJob).at(next_occurring)
        end
      end
    end
  end
end
