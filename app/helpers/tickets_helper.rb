require 'holidays'
require 'holidays/us'

module TicketsHelper

  def import_ticket(t)
    zenid = t.assignee_id
    if zenid
      @user = User.find_or_create_by(zenid: zenid)
    end
    originally_solved = t.metric_set.solved_at.in_time_zone('Eastern Time (US & Canada)') if t.metric_set.solved_at
    originally_created = t.metric_set.created_at.in_time_zone('Eastern Time (US & Canada)') if t.metric_set.created_at
    solved = business_time(originally_solved) if originally_solved
    created = business_time(originally_created) if originally_created

    product = ""
    closed_time = 0

    if solved and created < solved
      closed_time = closing_time(created, solved)
    end

    t.custom_fields.each do |c|
      if c.id == 22455799
        product = c.value
      end
    end

    first_assigned = t.metric_set.initially_assigned_at.in_time_zone('Eastern Time (US & Canada)') if t.metric_set.initially_assigned_at

    ticket = Ticket.find_or_initialize_by(zenid: t.id)

    ticket.update(opened: created, closed: solved,
                    first_assigned: first_assigned,
                    reply_time: t.metric_set.reply_time_in_minutes.business,
                    agent: t.assignee_id, product: product, closed_time: closed_time,
                    user_id: @user.id, originally_created: originally_created,
                    originally_closed: originally_solved, replies: t.metric_set.replies)
  end

  def business_time(datetime)
    day = datetime.strftime("%A")
    hour = datetime.strftime("%H").to_i

    if (day == "Sunday") or (day == "Saturday") or (hour >= 18) or (hour < 8)
      make_business(datetime, day, hour)
    else
      datetime
    end
  end

  def make_business(datetime, day, hour)

    addtl_days = 0.days

    if day == "Saturday"
      addtl_days = 2.days
    elsif day == "Sunday"
      addtl_days = 1.day
    elsif hour >= 18
      if day == "Friday"
        addtl_days = 3.days
      else
        addtl_days = 1.day
      end
    end

    adj_start(datetime, addtl_days)

  end

  def adj_start(datetime, more_days)
    (datetime+more_days).beginning_of_day + 8.hours
  end

  def closing_time(open, close)
    days = how_many_days(open, close)
    subtract_this = 0
    days.times do |i|
      next_day = (open+i.days).strftime("%A")
      if next_day == "Saturday" or next_day == "Sunday"
        subtract_this += 24.hours
      else
        subtract_this += 14.hours
      end
    end
    difference_between(open, close, subtract_this)
  end

  def how_many_days(open, close)
    ((close.beginning_of_day - open.beginning_of_day) / 60 / 60 / 24).to_i
  end

  def difference_between(open, close, subtract_this)
    diff = close - open - subtract_this
    if diff > 0
      diff.to_i / 60
    else
      0
    end
  end

end
