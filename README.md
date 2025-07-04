# Ticket Notifications

This application automates sending due date reminders for tickets based on user preferences.
The system allows each user to configure notification preferences per notification type. This includes enabling/disabling specific notification methods and setting custom properties for each method.

## Environment

* Ruby: 3.2.6
* Rails 7.0+
* Database: PostgreSQL
* Redis
* Containerization: Docker
* Testing: RSpec

## Prerequisites

Before getting started, ensure that you have the following installed:

- Docker
- Docker Compose

If you haven't already, you can install [Docker](https://www.docker.com/get-started) and [Docker Compose](https://docs.docker.com/compose/install/) on your machine.

## Setup and Installation

1. **Create the Docker network**:  
   The application requires a specific Docker network for communication between services. Create it by running:
   
   ```sh
   docker network create ticket-notification_private_network
   ```

2. **Build and start the containers**: 

   ```sh
   docker-compose up
   ```

3. **Access the application**:  
   Once the services are up and running, the web server will be available at:
   - http://localhost:3000

## Running Tests

To run the tests with RSpec, execute the following command:

```sh
docker compose exec app rspec
```

## Running the Application

1. **Access Rails console**:

   ```sh
   docker exec -it ticket-notification rails c
   ```

2. **Create the required data**:

   1. **Create a user**:
   
      ```ruby
      user = User.create!(
        name: "Project Manager",
        email: "manager@example.com",
        time_zone: "Europe/Vienna"
      )
      ```

   2. **Configure Notification Settings**:
   
      ```ruby
      setting = UserNotificationSetting.create!(
        user: user,
        notification_type: "email",
        send_due_date_reminder: true,
        due_date_reminder_interval: 1, # 1 day before
        due_date_reminder_time: "09:00" # 9 AM
      )
      ```

   3. **Create a ticket**:
   
      ```ruby
      ticket = Ticket.create!(
        title: "Fix Roof Leak",
        description: "Water leaking in conference room",
        assigned_user: user,
        due_date: 1.day.from_now, # Due tomorrow
        status: "open"
      )
      ```

   4. **Execute the reminder job**:
   
      ```ruby
      DueDateReminderJob.perform_now
      ```

   5. **Check the result**:
   
      ```ruby
      SentReminder.all.each do |reminder|
        puts "Sent at: #{reminder.sent_at}"
        puts "Ticket: #{reminder.ticket.title}"
        puts "User: #{reminder.user_notification_setting.user.name}"
      end
      ```
