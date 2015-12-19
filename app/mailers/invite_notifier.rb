class InviteNotifier < ActionMailer::Base
	default :from => 'do-not-reply@invtr.com'
	def send_invite_email(current_url = "http://localhost:3000/", email, invite)
		@current_url = current_url
		@invite = invite
		@email = email
  		mail( :to => @email,
  		:subject => 'Thanks for signing up for our amazing app' )
	end
end
