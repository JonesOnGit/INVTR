class InvitesController < ApplicationController
	require 'digest' 
	include AuthHelper
	before_action :authenticate_user!, only: [:deactivate]

	def new
		@invite = Invite.new
		@contacts = nil
		@google_login = google_login

		
	end 

	def show
		@invite = Invite.find(params[:id])
		@accepted_count = 0
		@declined_count = 0
		if @invite.accepted
			@accepted_count = @invite.accepted.count
		end

		if @invite.declined
			@declined_count = @invite.declined.count
		end
		unless session[:user_email] == @invite.owner
			session.clear
		end
		@email = session[:user_email]
		if not current_user
			unless @invite and @invite.active == true
				flash[:notice] = "That invite does not exist or has been deactivated"
				redirect_to root_path
			end
		end
	end

	def edit
		cookies.delete(:invited)
		@invite = Invite.find(params[:id])
		unless @invite.owner == session[:user_email]
			flash[:notice] = "You do not have permission to edit this Invitation."
			redirect_to root_path
		end
	end

	def create
		@invite = Invite.new(parse_params) 

		# @invite.invited = ["andy.n.gimma@gmail.com", "jessica@herenow.nyc"]
    @invite.invited = ["jd@startuplandia.io"]
		@invite.oauth_provider = session[:oauth_provider] || cookies[:oauth_provider]
		@invite.owner = session[:user_email] || cookies[:ownerEmail]

		if cookies[:oauth_provider] == "none"
			@invite.noauth_password = Digest::SHA1.hexdigest(@invite.to_s)[0..5]
		end

		if @invite.save
			session[:user_email] = @invite.owner
			session[:contacts] = nil
			
			Log.create(type: "Invite", action: "save", data: @invite.to_json, ip: request.ip, invite_id: @invite.id)
			if @invite.oauth_provider == "none"
				@invite.generate_token
				@invite.send_noauth_validation(request.base_url)
			else
				@invite.send_invites(request.base_url)
				@invite.send_owner_invite(request.base_url)
				@invite.email_validated = true
				@invite.save
			end
		    
		    flash[:notice] = "Invite #{@invite.name} saved."
		 	redirect_to invite_path(@invite)
		else
		    flash[:alert] = "Invite #{@invite.name} not saved."
		    render :new
		end
	end

	def update
		@invite = Invite.find(params[:id])
		# new_invites = cookies["invited"].split(/ /)
		# old_invites = @invite.invited
		# invites = new_invites + old_invites
		# @invite.invited = invites.uniq!
		if params[:invite][:messages]
			@invite.send_message(params[:message_group], params[:invite][:messages], @invite)
			render json: {message: params[:invite][:messages], to: params['message_group']}, status: 200
		else 
			unless @invite.owner == session[:user_email]
				flash[:notice] = "You do not have permission to edit this Invitation."
				redirect_to root_path
			end
			if  @invite.update_attributes(parse_params)
				Log.create(type: "Invite", action: "update", data: @invite.to_json, ip: request.ip, invite_id: @invite.id)

			    flash[:notice] = "Invite #{@invite.name} successfully updated."
			    @invite.send_updates(request.base_url)
			    redirect_to invite_path(@invite)
			else
			    flash[:alert] = "Invite #{@invite.name} not updated."
			    redirect_to new_invite_path(@invite)
			end
		end
	end

	def destroy
		@invite = Invite.find(params[:id])
        @invite.destroy
        flash[:alert] = "Invite Deleted" 
        redirect_to new_invite_path
	end

	def validate
		@invite = Invite.find_by(noauth_token: params[:noauth_token])
		@invite.email_validated = true
		@invite.save
		@invite.send_invites(request.base_url)
		@invite.send_owner_invite(request.base_url)
		session[:user_email] = @invite.owner
		redirect_to invite_path(@invite)
	end

	def accept
		@email = params[:email]
		@invite = Invite.find(params[:id])
		@change_url = "/invites/#{@invite.id}/decline?email=#{@email}"
		@invite.accept(@email)
		Log.create(type: "Invite", action: "accept", data: {id: @invite.id}, ip: request.ip, invite_id: @invite.id)

	end

	def decline
		@email = params[:email]
		@invite = Invite.find(params[:id])
		@change_url = "/invites/#{@invite.id}/accept?email=#{@email}"
		@invite.decline(@email)
		Log.create(type: "Invite", action: "decline", data: {id: @invite.id}, ip: request.ip, invite_id: @invite.id)
	end

	def report
		@invite = Invite.find(params[:id])
		@invite.add_report_count
		Log.create(type: "Invite", action: "report", data: {id: @invite.id}, ip: request.ip, invite_id: @invite.id)
	end

	def create_report
		@invite = Invite.find(params[:id])
		@invite.add_report_text(report_params[:reports])
		Log.create(type: "Invite", action: "create_report", data: {id: @invite.id, report_text: report_params[:reports]}, ip: request.ip, invite_id: @invite.id)
	end

	def deactivate
		@invite = Invite.find(params[:id])
		@invite.active = false
		@invite.deactivation_reason = params[:invite][:deactivation_reason]
		@invite.save
		flash[:alert] = "Invite #{@invite.name} deactivated"
		redirect_to "/admin"
	end

    private
    	def report_params
    		params.require(:invite).permit(:reports)
    	end

	    def invite_params
	        params.require(:invite).permit(:name,:start_date,:end_date,:description,:allow_others,:address,:avatar,:messages,:invite_start_date,:invite_start_hour,:invite_start_minute,:invite_start_am_pm,:invite_end_date,:invite_end_hour,:invite_end_minute,:invite_end_am_pm)
	    end

	    def parse_params
	    	return invite_params if invite_params.has_key? "start_date"

	    	ip = invite_params
	    	year = ip["invite_start_date"][6..9]
	    	year = year + "/" + ip["invite_start_date"]
	    	year.slice!(ip["invite_start_date"][5..9])
	    	year = year.gsub("/", "-")

	    	endyear = ip["invite_end_date"][6..9]
	    	endyear = endyear + "/" + ip["invite_end_date"]
	    	endyear.slice!(ip["invite_end_date"][5..9])
	    	endyear = endyear.gsub("/", "-")

	    	start_date = year + " " + ip["invite_start_hour"] + ":" + ip["invite_start_minute"]
	    	end_date = endyear + " " + ip["invite_end_hour"] + ":" + ip["invite_end_minute"]

	    	ip = delete_params ip
	    	
	    	ip["start_date"] = start_date
	    	ip["end_date"] = end_date
	    	return ip
	    end

	    def delete_params ip
	    	ip.delete("invite_start_date")
	    	ip.delete("invite_start_minute")
	    	ip.delete("invite_start_hour")
	    	ip.delete("invite_end_date")
	    	ip.delete("invite_end_minute")
	    	ip.delete("invite_end_hour")
	    	return ip
	    end

end
