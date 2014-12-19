json.array!(@problems) do |problem|
  json.extract! problem, :id, :title, :Description, :level_id
  json.url problem_url(problem, format: :json)
end
