class ReminderService
  def self.process 
    raise NotImplementedError, "This method should be implemented in a subclass"
  end

  protected

  def self.process_settings(notification_type)
    UserNotificationSetting
      .where(notification_type: notification_type, send_due_date_reminder: true)
      .includes(:user)
      .find_each do |setting| 
        next unless setting.user

        reminder_time = setting.next_reminder_time 

        tickets = fetch_due_tickets(setting, reminder_time)
        process_tickets(tickets, setting)
    end
  end

  def self.deliver(ticket, setting)
    raise NotImplementedError, "This method should be implemented in a subclass"
  end

  private 
  
  def self.fetch_due_tickets(setting, reminder_time)
    # find the tickets for each user that are due today or in the future
    # and have not been resolved
    Ticket
      .where(assigned_user_id: setting.user_id)
      .where("due_date <= ?", reminder_time)
      .where.not(status: 'resolved')
  end

  def self.process_tickets(tickets, setting)
    tickets.each do |ticket|
      next if SentReminder.sent_recently?(ticket, setting)

      deliver(ticket, setting)
      sent_reminder = SentReminder.record_reminder(ticket, setting)
    end          
  end
end