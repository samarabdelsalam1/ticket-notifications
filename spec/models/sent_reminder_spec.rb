require 'rails_helper'
RSpec.describe SentReminder, type: :model do
  it { should belong_to(:ticket) }
  it { should belong_to(:user_notification_setting) }
  
  describe 'validations' do
    let!(:user) { create(:user) }
    let!(:user_notification_setting) { create(:user_notification_setting) }
    let!(:ticket) { create(:ticket) }

    it 'is valid with valid attributes' do
      sent_reminder = build(:sent_reminder, ticket: ticket, user_notification_setting: user_notification_setting)
      expect(sent_reminder).to be_valid
    end

    it 'is not valid without a ticket' do
      sent_reminder = build(:sent_reminder, ticket: nil, user_notification_setting: user_notification_setting)
      expect(sent_reminder).not_to be_valid
    end

    it 'is not valid without a user_notification_setting' do
      sent_reminder = build(:sent_reminder, user_notification_setting: nil, ticket: ticket)
      expect(sent_reminder).not_to be_valid
    end
  end
end