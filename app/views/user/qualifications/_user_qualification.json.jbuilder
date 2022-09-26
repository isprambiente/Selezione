json.extract! user_qualification, :id, :category, :title, :vote, :vote_type, :year, :istitute, :duration, :duration_type, :created_at, :updated_at
json.url user_qualification_url(user_qualification, format: :json)
