# spec/factories/tickets.rb
FactoryBot.define do
  factory :ticket do
    title { FFaker::Lorem.sentence }
    description { FFaker::Lorem.paragraph }
    due_date { 2.days.from_now }
    status { 'open' }
    association :assigned_user, factory: :user
  end
end