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
		session[:type] = "mobile"
		if session[:image] and session[:image_time] > DateTime.now - 1.hour
			@image = session[:image]
			Log.create(type: "Ad", action: "show", data: session[:ad], ip: request.ip, ad_id: session[:ad]["_id"], ad_size: session[:type])
		else

			@image = session[:image]
		end
	end
end
