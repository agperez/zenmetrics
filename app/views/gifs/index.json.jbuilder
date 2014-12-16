json.array!(@gifs) do |gif|
  json.extract! gif, :id, :url
  json.url gif_url(gif, format: :json)
end
