module AuthHelper
	require 'signet/oauth_2/client'

	def google_login

		client = Signet::OAuth2::Client.new(
		  :authorization_uri => 'https://accounts.google.com/o/oauth2/auth',
		  :token_credential_uri =>  'https://www.googleapis.com/oauth2/v3/token',
		  :client_id => '832245431959-4qt4jj9euf22pd3d6tdsqknrdd32nuem.apps.googleusercontent.com',
		  :client_secret => 'qgYA7byhHjubHF4gkc7movGm',
		  :scope => 'https://www.google.com/m8/feeds',
		  # :redirect_uri => 'http://invtr-staging.herokuapp.com/google_authorize'
		  :redirect_uri => 'http://localhost:8000/google_authorize'
		)
		google_logins = client.authorization_uri
	end
end
