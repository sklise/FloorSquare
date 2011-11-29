get '/' do
  response['Access-Control-Allow-Origin'] = '*'
  erb :front
end

#   SWIPES
#---------------------------------------

# Get last 50 swipes
get '/swipes/?' do
  content_type :json

  @app = App.first(:auth_key => params[:app_key])
  validate_app_key @app

  search = {}

  # Set search terms in specified in params.
  search[:created_at.lt] = params[:until] unless params[:until].nil?
  search[:created_at.gt] = params[:since] unless params[:since].nil?

  # If no time range is specified, set the limit to 50
  if search.empty?
    search[:limit] = 50
  end

  # Only get swipes from matching app
  search[:app_id] = @app.id
  # Sort by most recent.
  search[:order] = [:created_at.desc]
  # Maybe an app will have more than one device, let them specify which.
  search[:device_id] = params[:device_id] unless params[:device_id].nil?

  @swipes = Swipe.all(search)
  response['Access-Control-Allow-Origin'] = '*'
  return @swipes.to_json
end

post '/swipes/new/?' do
  content_type :json
  response['Access-Control-Allow-Origin'] = '*'

  puts params.inspect
  @app = App.first(:auth_key => params[:app_key])
  validate_app_key @app

  @swipe = Swipe.new
  @swipe.user_nnumber = params[:user_nnumber]
  @swipe.netid = params[:netid]
  @swipe.credential = params[:credential]
  @swipe.device_id = params[:device_id]
  @swipe.app_id = @app.id
  @swipe.extra = {"app_id_#{@app.id}" => params[:extra] }

  if @swipe.save
    @user = User.first(@swipe.user_nnumber)
    if not @user
      @user = User.new
      @user.nnumber = @swipe.user_nnumber
    end
    @user.extra ||= {}
    data = {
      :name => @user.name,
      :photo => @user.photo,
      :extra => @user.extra["app_id_#{@app.id}"],
      :swipeid=> @swipe.id
    }
    # return JSONP data
    return data.to_json
  else
    throw(:halt, [500, "Error saving item\n"])
  end
end

# Allows extra data to be added to a swipe, after the swipe occurs.
# Makes sense from a user perspective (swipe first, then do something)
post '/swipes/:id' do
  @app = App.first(:auth_key => params[:app_key])
  validate_app_key @app

  @swipe = Swipe.get(params[:id])

  extra = params[:extra]

  extra ||= {}
  if @swipe.extra["app_id_#{@app.id}"]
    new_extra = @swipe.extra["app_id_#{@app.id}"].merge(extra)
    @swipe.extra = {"app_id_#{@app.id}" => new_extra }
  else
    @swipe.extra = {"app_id_#{@app.id}" => extra }
  end

  if @swipe.save()
    response['Access-Control-Allow-Origin'] = '*'
    return @swipe.to_json
  else
    response['Access-Control-Allow-Origin'] = '*'
    throw(:halt, [500, "Error saving item\n"])
  end
end

#   MEMBERS
#---------------------------------------

# Get all users associated with this app
get '/members' do
  @app = App.first(:auth_key => params[:app_key])
  validate_app_key @app
  # This is a complicated relation that we don't currently have.
end

# Get a specific member
get '/members/:nnumber' do
  @app = App.first(:auth_key => params[:app_key])
  validate_app_key @app

  @user = User.get(params[:nnumber])

  extra = params[:extra]

  if not @user
    response['Access-Control-Allow-Origin'] = '*'
    throw(:halt, [404, "Member not found\n"])
  else
    if @user.extra
      new_extra= @user.extra["app_id_#{@app.id}"].merge(extra)
      @user.extra = {"app_id_#{@app.id}" => new_extra }
    else
      @user.extra = {"app_id_#{@app.id}" => extra }
    end

    if @user.save()
      response['Access-Control-Allow-Origin'] = '*'
      return @user.to_json
    else
      response['Access-Control-Allow-Origin'] = '*'
      throw(:halt, [500, "Error saving User\n"])
    end
  end
end

# Get the swipes belonging to a member
get '/members/:nnumber/swipes' do
  @app = App.first(:auth_key => params[:app_key])
  validate_app_key @app

  @user = User.get(params[:nnumber])
  if not @user
    response['Access-Control-Allow-Origin'] = '*'
    throw(:halt, [404, "Member not found\n"])
  else
    response['Access-Control-Allow-Origin'] = '*'
    return @user.swipes.to_json
  end
end

#   ADMIN
#---------------------------------------

get '/admin/' do
end

get '/admin/apps' do
end

get '/admin/apps/new' do
  # We should use datamapper's builtin api key field for this...
  # https://github.com/datamapper/dm-types/blob/master/lib/dm-types/api_key.rb
end

post '/admin/apps/new' do
end

get '/admin/apps/:id/' do
end

get '/admin/apps/:id/edit' do
end

put '/admin/apps/:id' do
end

delete '/admin/apps/:id' do
end

get '/admin/devices' do
end

get '/admin/devices/new' do
end

post '/admin/devices/new' do
end

get '/admin/devices/:id' do
end

get '/admin/devices/:id/edit' do
end

put '/admin/devices/:id' do
end

delete '/admin/devices/:id' do
end

#   SASS
#---------------------------------------

get '/stylesheets/style.css' do
  scss :style
end

#   404
#---------------------------------------

not_found do
  erb :notfound
end