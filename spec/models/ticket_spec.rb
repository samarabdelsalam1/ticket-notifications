require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it { should belong_to(:assigned_user) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:due_date) }

  describe 'due date validation' do
    let(:user) { create(:user) }
    let(:ticket) { build(:ticket, assigned_user: user) }
    
    context 'when due date is in the past' do
      it 'is not valid' do
        ticket.due_date = 1.minute.ago
        expect(ticket).not_to be_valid
        expect(ticket.errors[:due_date]).to include("can't be in the past")
      end
    end

    context 'when due date is in the future' do
      it 'is valid' do
        ticket.due_date  = 1.day.from_now
        
        expect(ticket).to be_valid
      end
    end

    context 'when updating a ticket to a past due date' do
      let!(:ticket) { create(:ticket) }

      it 'is valid' do
        ticket.due_date = 1.day.ago
        expect(ticket).to be_valid
      end
    end
  end
end