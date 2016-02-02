class Invite
	include Mongoid::Document
	include Mongoid::Timestamps
	include Geocoder::Model::Mongoid
	include Mongoid::Paperclip

	has_mongoid_attached_file :avatar
	
	geocoded_by :address
	after_validation :geocode
	before_save :get_timezone

	field :name, type: String
	field :address, type: String
	field :coordinates, :type => Array
	field :timezone, type: String
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
	field :deactivation_reason, type: String
	field :owner, type: String
	field :oauth_provider, type: String
	field :noauth_password, type: String
	field :noauth_token, type: String
	field :messages, type: String
	field :invite_start_am_pm, type: String
	field :invite_end_am_pm, type: String
	field :email_validated, type: Boolean, default: false



	validates :name, length: { maximum: 150 }
	validates :description, length: { maximum: 1000 }

	validates_presence_of :name, :start_date, :end_date, :description, :address, :allow_others

	validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

	def to_ics
	  event = Icalendar::Event.new
	  event.dtstart = self.start_date.strftime("%Y%m%dT%H%M%S")
	  event.dtend = self.end_date.strftime("%Y%m%dT%H%M%S")
	  event.summary = self.name
	  event.description = self.description
	  event.location = self.address
	  event.ip_class = "PRIVATE"
	  event
	end

	def send_invites(url)
		self.invited.each do |invite_email|
			InviteNotifier.send_invite_email(url, invite_email, self).deliver
		end
	end

	def send_noauth_validation(url)
		InviteNotifier.send_noauth_validation(url, self).deliver
	end

	def generate_token
		self.noauth_token = SecureRandom.uuid
		self.save
	end

	def send_updates(url)
		
		guests = nil
		
		if self.declined.nil?
			guests = self.invited
		else
			guests = self.invited - self.declined
		end

		guests.each do |invite_email|
			InviteNotifier.send_update_email(url, invite_email, self).deliver
		end

	end

	def send_owner_invite(url)
		if self.owner
			InviteNotifier.send_owner_invite(url, self.owner, self).deliver
		end
	end


	def send_message(to, message, invite)
		guests = nil
		if to == "attending"
			guests = invite.accepted
		end
		if to == "no-reply"
			invite.accepted = [] if invite.accepted.nil?
			invite.declined = [] if invite.declined.nil?
			guests = invite.invited - invite.accepted - invite.declined
		end
		if to == "all"
			guests = invite.invited
		end
		guests.each do |guest|
			InviteNotifier.send_message(guest, message, invite).deliver
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

	def get_timezone
		proxy = ENV['HTTP_PROXY']
		client = HTTPClient.new(proxy)
		target = "https://maps.googleapis.com/maps/api/timezone/json?location=#{self.coordinates[1]},#{self.coordinates[0]}&timestamp=1"
		result = client.get_content(target)
		parsed = JSON.parse(result)
		self.timezone = parsed["timeZoneId"]
	end
end