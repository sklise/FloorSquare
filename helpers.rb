def validate_app_key app
  if app.nil?
	  throw(:halt, [401, "Not Authorized\n"])
  end
end
