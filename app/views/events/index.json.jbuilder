json.array!(@events) do |event|
  json.extract! event, :id, :title, :description, :sentence, :release_time, :summary, :location, :category, :capacity, :price
  json.url event_url(event, format: :json)
end
