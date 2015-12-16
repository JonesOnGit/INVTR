class InviteNotifier < ActionMailer::Base
	default :from => 'do-not-reply@invtr.com'
	def send_invite_email(email, invite)
		@invite = invite
		@email = email
  		mail( :to => @email,
  		:subject => 'Thanks for signing up for our amazing app' )
	end
end
