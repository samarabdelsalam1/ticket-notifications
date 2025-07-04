class User < ApplicationRecord
  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :time_zone, presence: true, length: { maximum: 60 }
  validate :valid_time_zone
  # Associations
 has_many :tickets, foreign_key: :assigned_user_id, dependent: :destroy
 has_many :user_notification_settings, dependent: :destroy
  
  # Validates the time zone format
  def valid_time_zone
    return if time_zone.blank?

    unless ActiveSupport::TimeZone[time_zone]
      errors.add(:time_zone, 'is not a valid time zone')
    end
  end
end
