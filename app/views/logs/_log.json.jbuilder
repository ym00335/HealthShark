json.extract! log, :id, :start_time, :end_time, :meal, :meal_name, :calories, :rating, :created_at, :updated_at
json.url log_url(log, format: :json)
