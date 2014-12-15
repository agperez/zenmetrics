class AddOriginallyCreatedToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :originally_created, :datetime
  end
end
