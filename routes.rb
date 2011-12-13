# All routes for the Floorsquare dashboard and
# API. The base url is http://www.itpirl.com/floorsquare.

# Define the root (http://www.itpirl.com/floorsquare)
get '/' do
  response['Access-Control-Allow-Origin'] = '*'
  erb :front
end

#    APPS
#---------------------------------------
#Find all apps written with the API and display them after swipe
get '/dashboard' do
  # @apps = App.find(:all, :users => ["on_dashboard = true"])
  @apps = App.all
  @user = User.find(:first, :conditions => ["nnumber = ?", 19663226])
  erb :dashboard
end

#post the swipe
post '/dashboard' do
  @user = User.find(:first, :conditions => ["nnumber = ?", 19663226])
  redirect '/floorsquare/dashboard'
end

get '/dashboard/app' do
  @app = App.where(:auth_key => params[:app_key]).first
   validate_app_key @app

   user_ids = []
   @app.swipes.each do |swipe|
     user_ids << swipe.user_id
   end

   @users = User.find(user_ids)

   @users.to_json
end

# #get '/dashboard/app' do
# get '/'
#   @user = User.find(:first, :conditions => ["nnumber = ?", 19663226])
#   @apps = App.all
#   erb :select_apps
# end
post '/dashboard/app' do
  app_ids = params[:app_ids].split(',') #find all the apps and split them up
  app_ids.each do |app_id| #go through each app and make it an app_id 
    app_id.to_i #then make app id into an integer
    Swipe.new(:user_nnumber => 111111, :app_id => 11111) #create new Swipe instance in database with the nnumber and app id of app  
  end
end



#   SWIPES
#---------------------------------------
# Paths for swipe interaction.

#### Get swipes corresponding to an app.
get '/swipes/?' do
  # Return as json
  content_type :json

  # Look for an App matching the specified app_key parameter
  @app = App.find(:first, :conditions => ["auth_key = ?", params[:app_key]])
  # If `@app` is nill, throw a 401 error
  validate_app_key @app

  # Create a search hash to use as query conditions for Swipes
  # `query` is a string with placeholders for conditions
  # the placeholders are stored in the `conditions` hash.
  query = "app_id = :app_id"
  conditions = {:app_id => @app.id}

  # Restrict search to one device. Useful if an app has multiple devices
  # and only wants activity from one device.
  if not params[:device_id].nil?
    query += " AND device_id = :device_id"
    conditions[:device_id] = params[:device_id]
  end

  # Check to see if a specific time range was queried.
  # If there was no time range specified, return only 50.
  if params[:until].nil? && params[:since].nil?
    @swipes = Swipe.find(:all, :conditions => [query, conditions], :order => "created_at DESC", :limit => 50)
  else
    # Append to query to look for swipes with `created_at` exclusive
    # less than the parameter.
    if not params[:until].nil?
      query += " AND created_at <= :until"
      conditions[:until] = Date.parse(params[:until])
    end

    # Do the same for `since`, this is inclusive.
    if not params[:since].nil?
      query += " AND created_at >= :since"
      conditions[:since] = Date.parse(params[:since])
    end
    # Create the query with specified conditions and order by most recent.
    @swipes = Swipe.find(:all, :conditions => [query, conditions], :order => "created_at DESC")
  end

  # We now have a collection of Swipes stored in `@swipes` and
  # need to return them as json which we will do with this loop.
  # Include the associated User with each Swipe.
  swipe_response = []
  @swipes.each do |swipe|
    swipe_response << swipe.as_json(:include => :user)
  end

  # Allow cross-origin json access
  response['Access-Control-Allow-Origin'] = '*'
  # Finally, return the array of Swipes and ensure it's sent as json.
  swipe_response.to_json
end

#### POST a new swipe.
post '/swipes/new/?' do
  content_type :json

  # Look for an App matching the specified app_key parameter
  @app = App.find(:first, :conditions => ["auth_key = ?", params[:app_key]])
  # If `@app` is nill, throw a 401 error
  validate_app_key @app

  # Find the User that corresponds to the N Number
  @user = User.find(:first, :conditions => ["nnumber = ?", params[:user_nnumber]])

  # If the user is not found, throw 401. Floorsquare is only for ITP.
  throw(:halt, [401, "User N Number not recognized\n"]) if @user.nil?

  # Create a new Swipe with the submitted parameters
  @swipe = Swipe.create({
    :user_nnumber => params[:user_nnumber],
    :user_id => @user.id,
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