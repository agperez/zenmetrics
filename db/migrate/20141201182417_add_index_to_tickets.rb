class AddIndexToTickets < ActiveRecord::Migration
  def change
    add_index :tickets, :zenid
  end
end
