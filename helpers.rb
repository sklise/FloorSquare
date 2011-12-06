# A simple helper function to return a 401 error
# if the parameter is returned as nil.
def validate_app_key app
  if app.nil?
    throw(:halt, [401, "Not Authorized\n"])
  end
end