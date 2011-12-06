get '/' do
  response['Access-Control-Allow-Origin'] = '*'
  erb :front
end

#   SWIPES
#---------------------------------------

# Get last 50 swipes
get '/swipes/?' do
  content_type :json

  @app = App.where(:auth_key =>params[:app_key]).limit(1).first
  validate_app_key @app

  search = {}
  # Get swipes from matching App
  search[:app_id] = @app.id
  # Maybe an app will have more than one device, let them specify which.
  search[:device_id] = params[:device_id] unless params[:device_id].nil?

  if params[:until].nil? && params[:since].nil?
    @swipes = Swipe.where(search).order("created_at DESC").limit(50)
  else
    @swipes = Swipe.where(search).order("created_at DESC")
  end

  if not params[:until].nil?
    @swipes = @swipes.where("created_at <= :until", {:until => params[:until]})
  end

  if not params[:since].nil?
    @swipes = @swipes.where("created_at >= :since", {:since => params[:since]})
  end

  swipe_response = []

  @swipes.each do |swipe|
    newswipe = swipe.attributes
    newswipe["user"] = swipe.user.attributes if swipe.user
    swipe_response << newswipe
  end

  response['Access-Control-Allow-Origin'] = '*'
  return swipe_response.as_json(:except => [:updated_at, :app_id, :user_id, :netid])
end

post '/swipes/new/?' do
  content_type :json
  response['Access-Control-Allow-Origin'] = '*'

  @app = App.where(:auth_key => params[:app_key]).limit(1).first
  validate_app_key @app

  @user = User.where(:nnumber => params[:user_nnumber]).first
  if @user.nil?
    @user = User.create(:nnumber => params[:user_nnumber])
  end

  @swipe = Swipe.create({
    :user_nnumber => params[:user_nnumber],
    :user_id => @user.id,
    :netid => params[:netid],
    :credential => params[:credential],
    :device_id => params[:device_id],
    :app_id => @app.id,
    :extra => {"app_id_#{@app.id}" => params[:extra] }
  })

  if @swipe.save
    @user.extra ||= {}
    data = {
      :first => @user.first,
      :last => @user.last,
      :netid => @user.netid,
      :photo => @user.photo,
      :extra => @user.extra["app_id_#{@app.id}"],
      :swipeid=> @swipe.id
    }
    # return JSONP data
    response['Access-Control-Allow-Origin'] = '*'
    return data.to_json
  else
    throw(:halt, [401, "Error saving item\n"])
  end
end

# Allows extra data to be added to a swipe, after the swipe occurs.
# Makes sense from a user perspective (swipe first, then do something)
post '/swipes/:id' do
  @app = App.where(:auth_key => params[:app_key]).limit(1).first
  validate_app_key @app

  @swipe = Swipe.find(params[:id])

  extra = params[:extra]

  @swipe.extra ||= {}
  if @swipe.extra["app_id_#{@app.id}"]
    new_extra = @swipe.extra["app_id_#{@app.id}"].merge(extra)
    @swipe.extra = {"app_id_#{@app.id}" => new_extra }
  else
    @swipe.extra = {"app_id_#{@app.id}" => extra }
  end

  if @swipe.save
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
  @app = App.where(:auth_key => params[:app_key]).first
  validate_app_key @app

  user_ids = []
  @app.swipes.each do |swipe|
    user_ids << swipe.user_id
  end

  @users = User.find(user_ids)

  @users.to_json
end

# Get a specific member
get '/members/:nnumber' do
  @app = App.where(:auth_key => params[:app_key]).first
  validate_app_key @app

  @user = User.where(:nnumber => params[:nnumber]).first

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
  @app = App.where(:auth_key => params[:app_key]).first
  validate_app_key @app

  @user = User.where(:nnumber => params[:nnumber]).first
  if not @user
    response['Access-Control-Allow-Origin'] = '*'
    throw(:halt, [404, "Member not found\n"])
  else
    response['Access-Control-Allow-Origin'] = '*'
    return @user.swipes.to_json
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