module ApplicationHelper
	def check_user
	  if !current_user.present?
	    redirect_to new_user_session_path
	  end
	end
	def get_bg_image
		@image = "/assets/IMAGE_SP.jpg"
	end
end
