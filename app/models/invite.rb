class Invite
	include Mongoid::Document
	include Mongoid::Timestamps
	include Geocoder::Model::Mongoid
	geocoded_by :address
	after_validation :geocode

	field :name, type: String
	field :address, type: String
	field :coordinates, :type => Array
	field :start_date, type: DateTime
	field :end_date, type: DateTime
	field :description, type: String
	field :allow_others, type: Boolean 
	field :invited, type: Array
	field :accepted, type: Array
	field :declined, type: Array
	field :reports, type: Array
	field :report_count, type: Integer, default: 0
	field :active, type: Boolean, default: true

	validates :name, length: { maximum: 150 }
	validates :description, length: { maximum: 1000 }

	validates_presence_of :name, :start_date, :end_date, :description, :allow_others, :address

	def send_invites(url)
		self.invited.each do |invite_email|
			InviteNotifier.send_invite_email(url, invite_email, self).deliver
		end
	end

	def accept(email)
		self.accepted = [] unless self.accepted
		self.declined = [] unless self.declined

		self.accepted << email unless self.accepted.include? email
		self.declined.delete(email) if self.declined.include? email
		self.save
	end

	def decline(email)
		self.accepted = [] unless self.accepted
		self.declined = [] unless self.declined

		self.declined << email unless self.declined.include? email
		self.accepted.delete(email) if self.accepted.include? email
		self.save
	end

	def add_report_text(text)
		self.reports = [] unless self.reports

		self.reports << text
		self.save
	end

	def add_report_count
		self.report_count = 0 unless self.report_count

		self.report_count += 1
		self.save
	end
end