require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:time_zone) }
  
  it { should have_many(:user_notification_settings) }
  it { should have_many(:tickets).with_foreign_key(:assigned_user_id).dependent(:destroy) }
 
  describe 'email uniqueness' do
    let!(:existing_user) { create(:user, email: 'test@example.com') }
    
    it 'validates case-insensitive uniqueness' do
      new_user = build(:user, email: 'TEST@example.com')
      expect(new_user).not_to be_valid
      expect(new_user.errors[:email]).to include('has already been taken')
    end
  end

  describe 'time_zone validation' do
    it 'accepts valid time zones' do
      user = build(:user, time_zone: 'Europe/Vienna')
      expect(user).to be_valid
    end
    
    it 'rejects invalid time zones' do
      user = build(:user, time_zone: 'Invalid/Zone')
      expect(user).not_to be_valid
    end
  end
end