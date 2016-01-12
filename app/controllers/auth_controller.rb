class AuthController < ApplicationController
	include AuthHelper

	def google_authorize
		binding.pry
	end

	def gettoken
	  token = get_token_from_code params[:code]
	  email = get_email_from_id_token token.params['id_token']
	  session[:azure_access_token] = token.token
	  bearer_token = session[:azure_access_token]

	  session[:user_email] = email
	  if bearer_token
	       # If a token is present in the session, get messages from the inbox
	       conn = Faraday.new(:url => 'https://outlook.office.com') do |faraday|
	         # Outputs to the console
	         faraday.response :logger
	         # Uses the default Net::HTTP adapter
	         faraday.adapter  Faraday.default_adapter  
	       end
	       
	       response = conn.get do |request|
	         # Get contacts from the default contacts folder
	         # Sort by GivenName in ascending orderby
	         # Get the first 10 results
	         request.url '/api/v2.0/Me/Contacts?$orderby=GivenName asc&$select=GivenName,Surname,EmailAddresses&$top=10'
	         request.headers['Authorization'] = "Bearer #{bearer_token}"
	         request.headers['Accept'] = "application/json"
	         request.headers['X-AnchorMailbox'] = email
	       end
	       @contacts = JSON.parse(response.body)['value']
	       # session[:contacts] = @contacts
	       AddressCache.create(session_id: session.id, contacts: @contacts)
	       session[:oauth_provider] = "hotmail"
	     else
	       # If no token, redirect to the root url so user
	       # can sign in.
	       redirect_to root_url
	     end

	  redirect_to root_path show_modal: true
	end
end

