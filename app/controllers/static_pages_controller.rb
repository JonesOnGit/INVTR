class StaticPagesController < ApplicationController
	def terms_of_service
		@static_page = true
	end

	def privacy_policy
		@static_page = true
	end

	def about
		@about_page = true
	end
end
