json.array! Profile.where('lower(first_name) like ?', "%#{params[:name].downcase}%").take(10) do |person|
  json.first person.first_name
  json.last person.last_name
  json.username person.username
  json.avatar person.avatar.small.url
end