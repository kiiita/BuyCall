json.array!(@users) do |user|
  json.extract! user, :id, :tel, :name, :zip, :address1, :address2
  json.url user_url(user, format: :json)
end
