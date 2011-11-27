get '/' do
  erb :front
end

#   ADMIN
#---------------------------------------

get '/admin/' do
end

get '/admin/apps' do
end

get '/admin/apps/new' do
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


post '/swipe/new' do
	netid = params[:netid]
	app_id = params[:app_id]
	device_id = params[:device_id]

	user = User.get(netid)
	if not user
		return('get off the floor, yo')
	
	else
		@swipe = Swipe.create()
		@swipe.netid= netid
		@swipe.app_id= app_id
		@swipe.device_id= device_id
		@swipe.save()

		content_type :json
	  	return { 'name' => user.name, 'photo' => user.photo }.to_json

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