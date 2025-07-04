class CreateSentReminders < ActiveRecord::Migration[7.2]
  def change
    create_table :sent_reminders do |t|
      t.references :ticket, null: false, foreign_key: true
      t.references :user_notification_setting, null: false, foreign_key: true
      t.datetime :sent_at, null: false, default: -> { "now()" }
    end

    add_index :sent_reminders, 
              [:ticket_id, :user_notification_setting_id, :sent_at],
              name: 'index_reminder_deliveries'
  end
end
