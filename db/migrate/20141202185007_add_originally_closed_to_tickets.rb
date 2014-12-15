class AddOriginallyClosedToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :originally_closed, :datetime
  end
end
