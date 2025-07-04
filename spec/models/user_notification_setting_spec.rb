require 'rails_helper'
RSpec.describe UserNotificationSetting, type: :model do
  it { should belong_to(:user) }
  it { should validate_presence_of(:notification_type) }

  describe 'email notification settings' do
    let(:user) { create(:user) }
    let(:setting) { create(:user_notification_setting, user: user, notification_type: 'email') }

    it 'is valid with valid attributes' do
      expect(setting).to be_valid
    end

    it 'sends due date reminders by default' do
      expect(setting.send_due_date_reminder).to be true
    end
  end
end