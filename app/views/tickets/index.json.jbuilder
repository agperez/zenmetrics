json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :zenid, :opened, :closed, :first_assigned, :closed_time, :reply_time, :product, :agent
  json.url ticket_url(ticket, format: :json)
end
