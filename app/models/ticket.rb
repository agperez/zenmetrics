class Ticket < ActiveRecord::Base
  belongs_to :user
  
  def self.in_month(month, product)
    where("opened >= ? AND opened <= ? AND product = ?", month.beginning_of_month, month.end_of_month, product)
  end

  def self.by_day(period, day, product)
    if period == "week"
      beginning = day.beginning_of_week
      ending = day.end_of_week
    elsif period == "day"
      beginning = day.beginning_of_day
      ending = day.end_of_day
    elsif period == "month"
      beginning = day.beginning_of_month
      ending = day.end_of_month
    end
    where("opened >= ? AND opened <= ? AND product = ?", beginning, ending, product)
  end
end
