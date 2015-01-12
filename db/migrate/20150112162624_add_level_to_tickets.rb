class AddLevelToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :level, :string
  end
end
