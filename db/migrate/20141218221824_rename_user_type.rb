class RenameUserType < ActiveRecord::Migration
  def change
    rename_column :users, :type, :agent_type
  end
end
