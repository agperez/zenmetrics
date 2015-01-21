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
    level = ""
    closed_time = 0

    if solved and created < solved
      closed_time = closing_time(created, solved)
    end

    t.custom_fields.each do |c|
      if c.id == 22455799
        product = c.value
      elsif c.id == 23381279
        level = c.value
      end
    end

    first_assigned = t.metric_set.initially_assigned_at.in_time_zone('Eastern Time (US & Canada)') if t.metric_set.initially_assigned_at

    ticket = Ticket.find_or_initialize_by(zenid: t.id)

    ticket.update(opened: created, closed: solved,
                    first_assigned: first_assigned,
                    reply_time: t.metric_set.reply_time_in_minutes.business,
                    agent: t.assignee_id, product: product, closed_time: closed_time,
                    user_id: @user.id, originally_created: originally_created,
                    originally_closed: originally_solved, replies: t.metric_set.replies,
                    level: level)
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

  def get_average(tickets)
    avg = Hash.new
    first_sum = 0
    close_sum = 0
    i = 0
    tickets.each do |t|
      if t.closed_time && t.reply_time
        first_sum += t.reply_time
        close_sum += t.closed_time
        i += 1
      end
    end

    avg["first"] = (i > 0 ? first_sum.to_f / i : 0)
    avg["close"] = (i > 0 ? close_sum.to_f / i : 0)
    avg["total"] = i
    return avg
  end

  def make_month_view(month, audit)
    @prospector_tix = Ticket.by_day("month", month, "prospector")
    @cadence_tix    = Ticket.by_day("month", month, "cadence")
    @audit          = RefreshAudit.last_refreshed("day") if audit == true

    pro_averages = get_average(@prospector_tix)
    @pro_total_closed = pro_averages["total"]
    @pro_first_avg    = pro_averages["first"]
    @pro_close_avg    = pro_averages["close"]

    cad_averages = get_average(@cadence_tix)
    @cad_total_closed = cad_averages["total"]
    @cad_first_avg    = cad_averages["first"]
    @cad_close_avg    = cad_averages["close"]
  end

  def make_week_view(week)
    @prospector_tix   = Ticket.by_day("week", week, "prospector")
    @cadence_tix      = Ticket.by_day("week", week, "cadence")
  end

  def make_days
    @p_monday     = []
    @p_tuesday    = []
    @p_wednesday  = []
    @p_thursday   = []
    @p_friday     = []
    @p_weekend    = []
    @prospector_tix.each do |t|
      case t.opened.strftime("%A")
      when "Monday"
        @p_monday << t
      when "Tuesday"
        @p_tuesday << t
      when "Wednesday"
        @p_wednesday << t
      when "Thursday"
        @p_thursday << t
      when "Friday"
        @p_friday << t
      when "Saturday"
        @p_weekend << t
      when "Sunday"
        @p_weekend << t
      end
    end
    @c_monday     = []
    @c_tuesday    = []
    @c_wednesday  = []
    @c_thursday   = []
    @c_friday     = []
    @c_weekend    = []
    @cadence_tix.each do |t|
      case t.opened.strftime("%A")
      when "Monday"
        @c_monday << t
      when "Tuesday"
        @c_tuesday << t
      when "Wednesday"
        @c_wednesday << t
      when "Thursday"
        @c_thursday << t
      when "Friday"
        @c_friday << t
      when "Saturday"
        @c_weekend << t
      when "Sunday"
        @c_weekend << t
      end
    end
  end

  def get_tiers(pro, cad)
    @tier1 = []
    @tier2 = []
    @tier3 = []

    pro.each do |t|
      if t.level == "tier_1"
        @tier1 << t
      elsif t.level == "tier_2"
        @tier2 << t
      elsif t.level == "tier_3"
        @tier3 << t
      end
    end

    cad.each do |t|
      if t.level == "tier_1"
        @tier1 << t
      elsif t.level == "tier_2"
        @tier2 << t
      elsif t.level == "tier_3"
        @tier3 << t
      end
    end

    t1_avg = get_average(@tier1)
    t2_avg = get_average(@tier2)
    t3_avg = get_average(@tier3)
    @tier1_response = t1_avg["first"]
    @tier2_response = t2_avg["first"]
    @tier3_response = t3_avg["first"]


  end

end
