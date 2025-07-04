FactoryBot.define do
  factory :user_notification_setting do
    user
    notification_type { 'email' }
    send_due_date_reminder { true }
    due_date_reminder_interval { 1 }
    due_date_reminder_time { '09:00' }
  end
end