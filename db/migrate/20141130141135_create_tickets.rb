class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :zenid
      t.datetime :opened
      t.datetime :closed
      t.datetime :first_assigned
      t.integer :closed_time
      t.integer :reply_time
      t.string :product
      t.string :assignee

      t.timestamps
    end
  end
end
