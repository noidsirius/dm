json.array!(@bids) do |bid|
  json.extract! bid, :id, :profile_id, :auction_id, :price
  json.url bid_url(bid, format: :json)
end
