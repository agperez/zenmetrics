class Api::TicketsController < Api::BaseController
  def stats
    make_month_view(Time.now, false)
    stats = {
      prospector_total_month:     @prospector_tix.count,
      cadence_total_month:        @cadence_tix.count,
      prospector_first_response:  @pro_first_avg.round(1),
      cadence_first_response:     @cad_first_avg.round(1)
    }
    respond_with stats
  end
end
