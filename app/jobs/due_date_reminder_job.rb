class DueDateReminderJob < ApplicationJob 
  queue_as :default

  def perform
    EmailReminderService.process
  end
end