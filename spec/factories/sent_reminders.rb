FactoryBot.define do
  factory :sent_reminder do
    association :ticket
    association :user_notification_setting
  end
end