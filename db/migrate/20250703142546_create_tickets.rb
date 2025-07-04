class CreateTickets < ActiveRecord::Migration[7.2]
  def change
    create_table :tickets, id: false do |t|
      t.primary_key :id, :integer
      t.string :title, limit: 255
      t.text :description, limit: 255
      t.date :due_date
      t.string :status, limit: 50, default: 'open'
      t.integer :assigned_user_id
      t.timestamps
    end
    add_foreign_key :tickets, :users, column: :assigned_user_id
  end
end 