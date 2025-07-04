# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_07_03_182553) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sent_reminders", force: :cascade do |t|
    t.bigint "ticket_id", null: false
    t.bigint "user_notification_setting_id", null: false
    t.datetime "sent_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id", "user_notification_setting_id", "sent_at"], name: "index_reminder_deliveries"
    t.index ["ticket_id"], name: "index_sent_reminders_on_ticket_id"
    t.index ["user_notification_setting_id"], name: "index_sent_reminders_on_user_notification_setting_id"
  end

  create_table "tickets", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.text "description"
    t.date "due_date"
    t.string "status", limit: 50, default: "open"
    t.integer "assigned_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_notification_settings", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "notification_type", null: false
    t.boolean "send_due_date_reminder"
    t.integer "due_date_reminder_interval"
    t.time "due_date_reminder_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "email", limit: 255
    t.string "time_zone", limit: 60
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "sent_reminders", "tickets"
  add_foreign_key "sent_reminders", "user_notification_settings"
  add_foreign_key "tickets", "users", column: "assigned_user_id"
  add_foreign_key "user_notification_settings", "users"
end
