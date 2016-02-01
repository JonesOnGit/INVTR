module ApplicationHelper
	def check_user
	  if !current_user.present?
	    redirect_to new_user_session_path
	  end
	end
	def get_bg_image
		session[:type] = "desktop"
		if request.env['HTTP_USER_AGENT'].include? "Android" or request.env['HTTP_USER_AGENT'].include? "iPhone"
			session[:type] = "mobile"
		end
		if session[:image] and session[:image_time] > DateTime.now - 1.second
			@image = session[:image]
			Log.create(type: "Ad", action: "show", data: session[:ad], ip: request.ip, ad_id: session[:ad]["_id"], ad_size: session[:type])
		else
			@ad = Ad.next
			session[:ad] = @ad
			now = DateTime.now
			@ad.last_served = now
			@ad.save
			if session[:type] == "mobile"
				session[:image] = @ad.mobile_location
			else
				session[:image] = @ad.desktop_location
			end

			session[:image_time] = now
			Log.create(type: "Ad", action: "show", data: session[:ad], ip: request.ip, ad_id: session[:ad]["_id"], ad_size: session[:type])

			@image = session[:image]
		end
	end
end
