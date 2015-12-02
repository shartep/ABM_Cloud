json.array!(@suppliers) do |supplier|
  json.extract! supplier, :id, :code, :name
  json.url supplier_url(supplier, format: :json)
end
