class Invite
	include Mongoid::Document
	include Mongoid::Timestamps

	field :name, type: String
	field :description, type: String

	validates :name, length: { maximum: 150 }
	validates :description, length: { maximum: 1000 }

	validates_presence_of :name, :description
end