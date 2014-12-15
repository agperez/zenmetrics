class AddIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :zenid
  end
end
