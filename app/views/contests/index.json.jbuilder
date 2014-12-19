json.array!(@contests) do |contest|
  json.extract! contest, :id, :title, :description, :release_time, :finished, :duration
  json.url contest_url(contest, format: :json)
end
