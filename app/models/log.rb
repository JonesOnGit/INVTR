class Log
	include Mongoid::Document
	include Mongoid::Timestamps

	field :type, type: String
	field :action, type: String
	field :data, type: String

	validates_presence_of :type, :action, :data

	def self.add_log type, action, data
		Log.create(type: type, action: action, data: data)
	end

end