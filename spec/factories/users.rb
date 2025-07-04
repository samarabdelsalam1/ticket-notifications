FactoryBot.define do
  factory :user do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    time_zone { ActiveSupport::TimeZone.all.map(&:name).sample }
    
    trait :with_email_notification do
      after(:create) do |user|
        create(:notification_setting, :email, user: user)
      end
    end
  end
end