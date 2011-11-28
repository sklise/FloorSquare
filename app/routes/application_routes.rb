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


post '/swipe/new' do
	netid = params[:netid]
	app_id = params[:app_id]
	device_id = params[:device_id]
	extra = params[:extra]

	user = User.get(netid)
	if not user
		return('get off the floor, yo!')
	
	else
		@swipe = Swipe.create()
		@swipe.netid= netid
		@swipe.app_id= app_id
		@swipe.device_id= device_id
		@swipe.extra= {"app_id_"+app_id => extra }
		@swipe.save()

		extra= user.extra["app_id_"+app_id]
		content_type :json
	  	return { :name => user.name, :photo => user.photo, :netid => netid, :extra => extra, :swipeid=> @swipe.id}.to_json
	end
end

# Allows extra data to be added to a swipe, after the swipe occurs. Makes sense from a user perspective (swipe first, then do something)
put '/swipe/:id' do
	netid = params[:netid]
	app_id = params[:app_id]
	extra = params[:extra]
	id = params[:id]

	user = User.get(netid)
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
	  	return swipe.to_json
	end
end

put '/user/:netid' do
	netid = params[:netid]
	app_id = params[:app_id]
	extra = params[:extra]

	user = User.get(netid)
	if not user
		return('get off the floor, yo!')
	else
		if user.extra
			new_extra= user.extra["app_id_"+app_id].merge(extra)
			user.extra = {"app_id_"+app_id => new_extra }
		else
			user.extra = {"app_id_"+app_id => extra }
		end

		user.save()
	  	return user.to_json
	end
end

get '/swipes/' do

	app_id = params[:app_id]
	# extra = params[:extra]
	
	app_swipes= Swipe.all(:app_id=>app_id)

	# matching_swipes = Array.new

	# return app_swipes.length.to_json

	# app_swipes.each do |swipe|
	# 	if swipe.extra
	# 		if swipe.extra["app_id_"+app_id.to_s] == extra
	# 			matching_swipes.push(swipe)
	# 		end
	# 	end
	# end


	if app_swipes.length > 0
		return app_swipes.to_json
	else
		return 'no swipes found'
	end

	# Failed attempts to use the built in filtering of datamapper

	# Swipe.all(:extra=>nil)
	# works
	# Swipe.all(:order => [ :id.desc ], :limit => 20)

	# Swipe.all(:extra => {:app_id => 1})
	# didn't make an error, also didn't work

	# ex={"app_id_1"=>{"checkin"=>"true"}}

	# Customer.all(Customer.orders.order_lines.item.sku.like => "%BLUE%")
	# Post.all(:comments => { :user => @user })
	# Swipe.all(Swipe.extra['app_id_1']['checkin']=>true)
	# fails

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