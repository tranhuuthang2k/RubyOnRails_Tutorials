json.extract! micropost, :id, :user_id, :content, :created_at, :updated_at
json.url micropost_url(micropost, format: :json)
