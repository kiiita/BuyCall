json.array!(@products) do |product|
  json.extract! product, :id, :name, :name_read, :price, :count
  json.url product_url(product, format: :json)
end
