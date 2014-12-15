class Ticket < ActiveRecord::Base
  belongs_to :user

  def self.in_month(month, product)
    where("opened >= ? AND opened <= ? AND product = ?", month.beginning_of_month, month.end_of_month, product)
  end
end
