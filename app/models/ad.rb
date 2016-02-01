class Ad
	include Mongoid::Document
	include Mongoid::Timestamps
	include Geocoder::Model::Mongoid


	field :name, type: String
	field :start_date, type: Date
	field :end_date, type: Date
	field :desc, type: String
	field :redirect_url, type: String
	field :last_served, type: DateTime
	field :mobile_location, type: String
	field :desktop_location, type: String

	validates_presence_of :name, :start_date, :end_date, :desc, :redirect_url
	def self.random
		@ads = Ad.where(active: true)
		count = @ads.count
		return @ads[rand(count)].avatar.url
	end

	def self.next
		Ad.where({'end_date' => {'$gte' => DateTime.now}}).where({'start_date' => {'$lte' => DateTime.now}}).order_by( [[ :last_served, :asc ]]).first
	end
end