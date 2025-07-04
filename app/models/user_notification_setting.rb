class UserNotificationSetting < ApplicationRecord


  # Validations
  validates :user_id, presence: true
  validates :notification_type, presence: true, length: { maximum: 50 }
  validates :send_due_date_reminder, inclusion: { in: [true, false] }
  validates :notification_type, uniqueness: { scope: :user_id, message: "already exists for this user" }
  validates :due_date_reminder_interval, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :notification_type, inclusion: { in: %w[email] }
  # Associations
  belongs_to :user

  # Scopes
  scope :enabled_notifications, -> { where(send_due_date_reminder: true) }
  
  # Methods
  def toggle_notification!
    update(send_due_date_reminder: !send_due_date_reminder)
  end

  # Converts settings to time object
  def reminder_time_today
    Time.current.change(
      hour: due_date_reminder_time.hour,
      min: due_date_reminder_time.min
    )
  end
  
  # Calculates exact UTC time for next reminder
  def next_reminder_time
    (Time.current + due_date_reminder_interval.days)
      .in_time_zone(user.time_zone)
      .change(
        hour: due_date_reminder_time.hour,
        min: due_date_reminder_time.min
      )
      .utc
  end
end
