class Ad
	include Mongoid::Document
	include Mongoid::Timestamps
	include Geocoder::Model::Mongoid
	include Mongoid::Paperclip

	has_mongoid_attached_file :avatar

	field :name, type: String
	field :start_date, type: Date
	field :end_date, type: Date
	field :desc, type: String
	field :active, type: Boolean

	validates_presence_of :name, :start_date, :end_date, :desc, :active

	validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

	def self.random
		@ads = Ad.where(active: true)
		count = @ads.count
		binding.pry
		return @ads[rand(count)].avatar.url
	end
end