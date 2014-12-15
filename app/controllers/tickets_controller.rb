class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]


  def index
    @tickets = Ticket.all
  end

  def stats
    stats = {
      cadence_tickets: Ticket.in_month(month, "cadence")
    }
    format.json { render json: stats }
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

    def make_month_view(month, audit)
      @prospector_tix = Ticket.in_month(month, "prospector")
      @cadence_tix    = Ticket.in_month(month, "cadence")
      @audit          = RefreshAudit.last_refreshed("day") if audit == true

      first_sum = 0
      close_sum = 0
      i=0
      @prospector_tix.each do |t|
        if t.closed_time && t.reply_time
          close_sum += t.closed_time
          first_sum += t.reply_time
          i+=1
        end
      end
      @pro_total_closed = i
      @pro_first_avg = first_sum.to_f / i
      @pro_close_avg = close_sum.to_f / i

      cad_first_sum = 0
      cad_close_sum = 0
      cad_i=0
      @cadence_tix.each do |t|
        if t.closed_time && t.reply_time
          cad_close_sum += t.closed_time
          cad_first_sum += t.reply_time
          cad_i+=1
        end
      end
      @cad_total_closed = cad_i
      @cad_first_avg = cad_first_sum.to_f / cad_i
      @cad_close_avg = cad_close_sum.to_f / cad_i
    end



end
