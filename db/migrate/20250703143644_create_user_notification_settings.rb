class CreateUserNotificationSettings < ActiveRecord::Migration[7.2]
  def change
    create_table :user_notification_settings, id: false do |t|
      t.primary_key :id, :integer
      t.integer :user_id
      t.string :notification_type, null: false
      t.boolean :send_due_date_reminder
      t.integer :due_date_reminder_interval
      t.time :due_date_reminder_time
      t.timestamps
    end
    add_foreign_key :user_notification_settings, :users, column: :user_id
  end
end
