class CreateRefreshAudits < ActiveRecord::Migration
  def change
    create_table :refresh_audits do |t|
      t.string :period
      t.datetime :stamp

      t.timestamps
    end
  end
end
