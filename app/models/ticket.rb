class Ticket < ApplicationRecord
  belongs_to :assigned_user, class_name: 'User', foreign_key: 'assigned_user_id'

  validates :title, presence: true
  validates :description, presence: true
  validates :due_date, presence: true
  validate :due_date_not_in_past, on: :create

  validates :assigned_user_id, presence: true
  validates :status, inclusion: { in: %w[open resolved pending] }

    private

  def due_date_not_in_past
    return if due_date.blank? || due_date >= Time.current

    errors.add(:due_date, "can't be in the past")
  end
end 