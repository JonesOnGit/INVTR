class AdsController < ApplicationController
	def session_image
		f = open('http://s3.amazonaws.com/invtr/ads/avatars/56a1/03e2/dfee/1b00/0300/0000/original/IMAGE_SP.jpg?1453392866')
		send_file f, :type => 'image/jpeg', :disposition => 'inline'
		return
	end
end
