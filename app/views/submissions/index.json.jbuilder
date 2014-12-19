json.array!(@submissions) do |submission|
  json.extract! submission, :id, :profile_id, :problem_id, :status, :description
  json.url submission_url(submission, format: :json)
end
