class InviteNotifier < ActionMailer::Base
	default :from => 'do-not-reply@invtr.com'
	def send_invite_email(current_url = "http://localhost:3000/", email, invite)
		@current_url = current_url
		@invite = invite
		@email = email
  		mail( :to => @email,
  		:subject => 'Thanks for signing up for our amazing app' )
	end

	def send_update_email(current_url = "http://localhost:3000/", email, invite)
		@current_url = current_url
		@invite = invite
		@email = email
  		mail( :to => @email,
  		:subject => "Update for #{@invite.name}" )
	end

	def send_owner_invite(current_url = "http://localhost:3000/", email, invite)
		@current_url = current_url
		@invite = invite
		@email = email
		@noauth_password = invite.noauth_password
		mail( :to => @email,
		:subject => @invite.name )
	end

	def send_message(to, message, invite)
		@invite = invite
		@message = message
		mail(:to => to,
			:subject => @invite.name)
	end

	def send_noauth_validation(current_url = "http://localhost:3000/", invite)
		@current_url = current_url
		@invite = invite
  		mail( :to => @invite.owner,
  		:subject => 'Please validate' )
	end
end
