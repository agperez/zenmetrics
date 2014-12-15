class AddRepliesToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :replies, :integer
  end
end
