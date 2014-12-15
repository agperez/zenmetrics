class StaticController < ApplicationController

  def home
    @tickets = []
    @i = 0
    client.tickets.all do |t|
      t.custom_fields.each do |cf|
        if cf.value == "prospector"
          @tickets << t
          @i += 1
        end
      end
    end

    # @comments = client.requests.find(:id => 564).comments
    # @author_ids
    # @comments.each do |c|
    #   @author_ids.store((c.author_id).to_s, client.users.find(:id => (c.author_id)).to_s)
    # end
  end

  def audits
    @tickets = []
    @i = 0
    client.tickets.include(:metric_sets).all do |t|
      t.custom_fields.each do |cf|
        if cf.value == "prospector"
          @tickets << t
          @i += 1
        end
      end
    end
  end

end
