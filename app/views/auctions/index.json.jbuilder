json.array!(@auctions) do |auction|
  json.extract! auction, :id, :name, :base_price, :start_time, :end_time, :problem_id
  json.url auction_url(auction, format: :json)
end
