require 'rails_helper'

RSpec.describe DueDateReminderJob, type: :job do
  include ActiveJob::TestHelper

  let!(:user) { create(:user, time_zone: 'Europe/Vienna') }
  let!(:setting) do
    create(:user_notification_setting, 
           user: user,
           notification_type: 'email',
           send_due_date_reminder: true,
           due_date_reminder_interval: 1,
           due_date_reminder_time: '09:00')
  end
  let!(:ticket) { create(:ticket, assigned_user: user, due_date: 1.day.from_now) }

  before do
    Timecop.freeze(Time.utc(2023, 1, 15, 7, 0, 0)) # 8 AM Vienna time (UTC+1)
    ActiveJob::Base.queue_adapter = :test
  end

  after do
    Timecop.return
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe '#perform' do
    it 'executes the email reminder service' do
      # Stub the email service
      allow(EmailReminderService).to receive(:process)
      
      # Perform the job
      perform_enqueued_jobs do
        DueDateReminderJob.perform_later
      end
      
      # Verify email service was called
      expect(EmailReminderService).to have_received(:process)
    end

it 'creates sent reminders through the service' do
  # Calculate the exact reminder time
  reminder_time = setting.next_reminder_time
  
  # Create a ticket that is clearly due within the reminder window
  # Set due_date to be exactly at the reminder time
  ticket = create(:ticket, 
                 assigned_user: user, 
                 due_date: reminder_time)
  
  # Verify the ticket should be processed
  expect(ticket.due_date).to be <= reminder_time
  expect(ticket.status).not_to eq('resolved')
  
  # Perform the job
  perform_enqueued_jobs do
    DueDateReminderJob.perform_later
  end
  
  # Verify reminders were created
  expect(SentReminder.count).to eq(1)
  reminder = SentReminder.last
  expect(reminder.ticket).to eq(ticket)
  expect(reminder.user_notification_setting).to eq(setting)
end

    it 'is enqueued in the default queue' do
      DueDateReminderJob.perform_later
      expect(DueDateReminderJob).to have_been_enqueued.on_queue('default')
    end

    context 'when no email settings exist' do
      before { UserNotificationSetting.delete_all }
      
      it 'completes without errors' do
        expect {
          perform_enqueued_jobs do
            DueDateReminderJob.perform_later
          end
        }.not_to raise_error
      end

      it 'does not create sent reminders' do
        expect {
          perform_enqueued_jobs do
            DueDateReminderJob.perform_later
          end
        }.not_to change(SentReminder, :count)
      end
    end
  end

  describe 'scheduling' do
    it 'enqueues the job' do
      expect {
        DueDateReminderJob.perform_later
      }.to have_enqueued_job(DueDateReminderJob)
    end

    it 'runs at the scheduled time' do
      # Schedule the job to run daily at 8 AM UTC
      job = DueDateReminderJob.set(wait_until: 1.day.from_now.at_beginning_of_day + 8.hours).perform_later
      
      # Verify scheduling
      expect(DueDateReminderJob).to have_been_enqueued.at(1.day.from_now.at_beginning_of_day + 8.hours)
    end
  end
end