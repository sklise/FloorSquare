get '/' do
  response['Access-Control-Allow-Origin'] = '*'
  erb :front
end

#   SWIPES
#---------------------------------------

# Get last 50 swipes
get '/swipes/?' do
  content_type :json
  response['Access-Control-Allow-Origin'] = '*'

  @app = App.first(:auth_key => params[:app_key])

  if @app.nil?
    throw(:halt, [401, "Not Authorized\n"])
  else
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
    @swipes.to_json
  end
end

post '/swipes/new' do
  content_type :json
  response['Access-Control-Allow-Origin'] = '*'

  @app = App.first(:auth_key => params[:app_key])

  if @app.nil?
    throw(:halt, [401, "Not Authorized\nMust provide a valid app_key."])
  else
    @swipe = Swipe.create({
      :user_nnumber => params[:user_nnumber],
      :netid => params[:netid],
      :credential => params[:credential],
      :device_id => params[:device_id],
      :app_id => @app.id,
      :extra => {"app_id_"+app_id => params[:extra] }
    })
  end

  if @swipe.save
    @user = User.first_or_create(@swipe.user_nnumber)
    extra= @user.extra[ "app_id_"+ app_id.to_s ]
    data= { :name => @user.name, :photo => @user.photo, :extra => extra, :swipeid=> @swipe.id}
    # return JSONP data
    return data.to_json
  else
    return "error"
  end
end

#   MEMBERS
#---------------------------------------

# Get all users associated with this app
get '/members' do
  
end

# Get a specific member
get '/members/:user_id' do
end

# Get the swipes belonging to a member
get '/members/:user_id/swipes' do
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

# Allows extra data to be added to a swipe, after the swipe occurs. Makes sense from a user perspective (swipe first, then do something)
post '/swipe/:id' do
  nnumber = params[:nnumber]
  app_id = params[:app_id]
  extra = params[:extra]
  id = params[:id]

  user = User.get(nnumber)
  if not user
    return('get off the floor, yo!')
  
  else
    swipe = Swipe.get(id)
    if swipe.extra
      new_extra= swipe.extra["app_id_"+app_id].merge(extra)
      swipe.extra = {"app_id_"+app_id => new_extra }

    else
      swipe.extra = {"app_id_"+app_id => extra }
    end

    swipe.save()
    response['Access-Control-Allow-Origin'] = '*'
      return swipe.to_json
  end
end


post '/user/:netid' do
  response['Access-Control-Allow-Origin'] = '*'

  netid = params[:netid]
  app_id = params[:app_id]
  extra = params[:extra]

  user = User.get(netid)
  if not user
    response['Access-Control-Allow-Origin'] = '*'
    return('get off the floor, yo!')
  else
    if user.extra
      new_extra= user.extra["app_id_"+app_id].merge(extra)
      user.extra = {"app_id_"+app_id => new_extra }
    else
      user.extra = {"app_id_"+app_id => extra }
    end

    user.save()

    response['Access-Control-Allow-Origin'] = '*'
      return user.to_json
  end
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