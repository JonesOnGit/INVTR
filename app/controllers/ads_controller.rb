class AdsController < ApplicationController
	def session_image
		# check if session image exists
		# if not, load random image and save as session image
		# set sesstion to expire in one hour
		# log which add was used
		if session[:image].nil?
			ad = Ad.offset(rand(Ad.count)).first
			session[:image] = ad.avatar.url
			begin
				f = open(session[:image])
			rescue
				# f.open("'http://s3.amazonaws.com/invtr/ads/avatars/56a1/03e2/dfee/1b00/0300/0000/original/IMAGE_SP.jpg?1453392866'")
			end
			send_file f, :type => 'image/jpeg', :disposition => 'inline'
			return
		else
			f = open(session[:image])
			send_file f, :type => 'image/jpeg', :disposition => 'inline'
			return
		end
	end
end
