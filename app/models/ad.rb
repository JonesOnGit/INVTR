class Ad
	include Mongoid::Document
	include Mongoid::Timestamps
	include Geocoder::Model::Mongoid
	include Mongoid::Paperclip

	has_mongoid_attached_file :avatar, styles : {
		half: '500x500>'
	}
	has_mongoid_attached_file :mobile

	field :name, type: String
	field :start_date, type: Date
	field :end_date, type: Date
	field :desc, type: String
	field :redirect_url, type: String
	field :last_served, type: DateTime

	validates_presence_of :name, :start_date, :end_date, :desc, :redirect_url

	validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
	validates_attachment_content_type :mobile, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

	def self.random
		@ads = Ad.where(active: true)
		count = @ads.count
		return @ads[rand(count)].avatar.url
	end

	def self.next
		Ad.where({'end_date' => {'$gte' => DateTime.now}}).where({'start_date' => {'$lte' => DateTime.now}}).order_by( [[ :last_served, :asc ]]).first
	end
end