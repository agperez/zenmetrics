json.array!(@users) do |user|
  json.extract! user, :id, :zenid, :name, :email
  json.url user_url(user, format: :json)
end
