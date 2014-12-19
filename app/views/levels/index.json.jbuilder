json.array!(@levels) do |level|
  json.extract! level, :id, :name, :price, :bounty
  json.url level_url(level, format: :json)
end
