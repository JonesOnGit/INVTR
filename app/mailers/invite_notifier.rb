class InviteNotifier < ActionMailer::Base
	default :from => 'do-not-reply@invtr.com'
	def send_invite_email(invite)
	  mail( :to => "andy.n.gimma@gmail.com",
	  :subject => 'Thanks for signing up for our amazing app' )
	end
end
