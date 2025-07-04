require 'rails_helper'

RSpec.describe EmailReminderService, type: :service do 
  let!(:user) { create(:user, time_zone: 'Europe/Vienna') }
  let!(:setting) do create(:user_notification_setting,
                           user: user,
                           notification_type: 'email', 
                           due_date_reminder_interval: 1,
                           send_due_date_reminder: true) 
  end
  
  describe ".process" do
    context "When tickets are due" do
      let!(:ticket) { create(:ticket, assigned_user: user, due_date: 1.day.from_now) }
      it "creates a SentReminder record" do
        Timecop.freeze(setting.next_reminder_time - 1.hour) do
          expect {
            EmailReminderService.process
          }.to change(SentReminder, :count).by(1)
        end
      end
    end

    context "When tickets are not due" do
      let!(:ticket) { create(:ticket, assigned_user: user, due_date: setting.next_reminder_time + 2.days) }
      it "does not send email reminders" do
        Timecop.freeze(setting.next_reminder_time - 1.hour) do
         expect {
            EmailReminderService.process
          }.not_to change(SentReminder, :count)
        end
      end
    end

    context "When tickets are resovled" do
       let!(:ticket) { create(:ticket, assigned_user: user, due_date: 1.day.from_now, status: 'resolved') }
      it "does not send email reminders" do
        Timecop.freeze(setting.next_reminder_time - 1.hour) do
          expect {
            EmailReminderService.process
          }.not_to change(SentReminder, :count)
        end
      end
    end

    context "When reminders have been sent recently" do
      let!(:ticket) { create(:ticket, assigned_user: user, due_date: 1.day.from_now) }
      
      before do
        create(:sent_reminder, ticket: ticket, user_notification_setting: setting)
      end
      it "does not send duplicate reminders" do 
         Timecop.freeze(setting.next_reminder_time - 1.hour) do
          expect {
            EmailReminderService.process
          }.not_to change(SentReminder, :count)
        end
      end
    end

    context "When notification settings are not enabled" do
      let!(:setting) { create(:user_notification_setting, send_due_date_reminder: false) }
      let!(:ticket) { create(:ticket, assigned_user: user, due_date: 1.day.from_now) }

      it "does not send email reminders" do
        Timecop.freeze(setting.next_reminder_time - 1.hour) do
          expect {
            EmailReminderService.process
          }.not_to change(SentReminder, :count)
        end
      end

    end
  end
end
  