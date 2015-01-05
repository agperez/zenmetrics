class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]


  def index
    @tickets = Ticket.all
  end

  def start_refresh
    SCHEDULER.every '30s', :first_in => 0 do |job|
      ids = []
      client.search(:query => "type:ticket created>#{(Time.now-1.days).strftime("%Y-%m-%d")}").each do |t|
        ids << t.id
      end

      ids_sanitized = ids.map(&:inspect).join(', ')
      client.tickets.show_many(:ids => ids_sanitized).include(:metric_sets).each do |t|
        import_ticket(t)
      end

      RefreshAudit.create(period: 'day', stamp: Time.now)
    end
    redirect_to month_path
  end

  def refresh_day
    ids = []
    client.search(:query => "type:ticket created>#{(Time.now-1.days).strftime("%Y-%m-%d")}").each do |t|
      ids << t.id
    end

    ids_sanitized = ids.map(&:inspect).join(', ')
    client.tickets.show_many(:ids => ids_sanitized).include(:metric_sets).each do |t|
      import_ticket(t)
    end

    RefreshAudit.create(period: 'day', stamp: Time.now)

    redirect_to month_path
  end

  def refresh
    client.tickets.include(:metric_sets).all do |t|
      import_ticket(t)
    end

    RefreshAudit.create(period: 'all', stamp: Time.now)
    redirect_to month_path
  end

  def month
    make_month_view(Time.now, true)
  end

  def previous
    make_month_view(Time.now - 1.month, false)
  end

  def week
    make_week_view(Time.now)
    make_days
  end

  def previous_week
    make_week_view(Time.now - 1.week)
    make_days
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_params)

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
        format.json { render :show, status: :created, location: @ticket }
      else
        format.html { render :new }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url, notice: 'Ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:zenid, :opened, :closed, :first_assigned, :closed_time,
                                   :reply_time, :product, :agent, :replies, :user_id)
  end
end
