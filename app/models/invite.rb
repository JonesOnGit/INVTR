class Invite
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String
	field :start_date, type: DateTime
	field :end_date, type: DateTime
	field :description, type: String
	field :allow_others, type: Boolean 

	validates :name, length: { maximum: 150 }
	validates :description, length: { maximum: 1000 }

	validates_presence_of :name, :start_date, :end_date, :description, :allow_others
end