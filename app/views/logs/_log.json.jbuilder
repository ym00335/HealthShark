json.extract! log, :id, :meal, :calories, :start_date, :end_date, :created_at, :updated_at
json.url log_url(log, format: :json)
