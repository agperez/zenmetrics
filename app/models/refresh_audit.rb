class RefreshAudit < ActiveRecord::Base

  def self.last_refreshed(period)
    where("period = ?", period).order("stamp DESC").first.stamp
  end
  
end
