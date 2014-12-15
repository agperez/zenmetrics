class RenameTicketAssigneeToAgent < ActiveRecord::Migration
  def change
    rename_column :tickets, :assignee, :agent
  end
end
