json.array!(@products) do |product|
  json.extract! product, :id, :sku, :supplier_code, :field_1, :field_2, :field_3, :field_4, :field_5, :field_6, :price
  json.url product_url(product, format: :json)
end
