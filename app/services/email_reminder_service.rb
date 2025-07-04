class EmailReminderService < ReminderService 
  def self.process
    process_settings('email')
  end

  protected

  def self.deliver(ticket, setting)
    # Logic to send email reminder
    # UserMailer.reminder_email(ticket, setting.user).deliver_now
    puts "Sending email reminder for Ticket ID: #{ticket.id} to User ID: #{setting.user_id}"
  end
end