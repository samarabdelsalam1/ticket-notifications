class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, id: false do |t|
      t.primary_key :id, :integer
      t.string :name, limit: 255
      t.string :email, limit: 255
      t.string :time_zone, limit: 60
      t.timestamps
    end
  end
end
