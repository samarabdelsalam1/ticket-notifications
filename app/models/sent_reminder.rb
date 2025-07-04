class SentReminder < ApplicationRecord
  # Associations
  belongs_to :ticket
  belongs_to :user_notification_setting

  # Validations
  validates :ticket_id, presence: true
  validates :user_notification_setting_id, presence: true

  # Scopes
  scope :recent, -> { order(sent_at: :desc) }

  # Methods
  def self.record_reminder(ticket, user_notification_setting)
    create(ticket: ticket, user_notification_setting: user_notification_setting)
  end

  # Check if a reminder was recently sent for this ticket/notification
  def self.sent_recently?(ticket, user_notification_setting)
    exists?(
      ticket: ticket,
      user_notification_setting: user_notification_setting,
      sent_at: 24.hours.ago..Time.current
    )
  end
end
