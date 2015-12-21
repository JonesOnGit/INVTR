class InvitesController < ApplicationController
	before_action :authenticate_user!, only: [:deactivate]

	def new
		@invite = Invite.new
	end 

	def show
		@invite = Invite.find(params[:id])
		if not current_user
			unless @invite and @invite.active == true
				flash[:notice] = "That invite does not exist or has been deactivated"
				redirect_to root_path
			end
		end
	end

	def edit
		@invite = Invite.find(params[:id])
	end

	def create
		@invite = Invite.new(parse_params) 

		@invite.invited = ["andy.n.gimma@gmail.com", "jessica@herenow.nyc"]

		if @invite.save
			Log.create(type: "Invite", action: "save", data: @invite.to_json, ip: request.ip)
			@invite.send_invites(request.base_url)
		    flash[:notice] = "Invite #{@invite.name} saved."
		 	redirect_to invite_path(@invite)
		else
		    flash[:alert] = "Invite #{@invite.name} not saved."
		    render :new
		end
	end

	def update
		@invite = Invite.find(params[:id])
		if  @invite.update_attributes(parse_params)
			Log.create(type: "Invite", action: "update", data: @invite.to_json, ip: request.ip)

		    flash[:notice] = "Invite #{@invite.name} successfully updated."
		    redirect_to invite_path(@invite)
		else
		    flash[:alert] = "Invite #{@invite.name} not updated."
		    redirect_to new_invite_path(@invite)
		end
	end

	def destroy
		@invite = Invite.find(params[:id])
        @invite.destroy
        flash[:alert] = "Invite Deleted" 

        #TODO set a better redirect
        redirect_to new_invite_path
        # redirect_to root_path
	end

	def accept
		@email = params[:email]
		@invite = Invite.find(params[:id])
		@invite.accept(@email)
		Log.create(type: "Invite", action: "accept", data: {id: @invite.id}, ip: request.ip)
	end

	def decline
		@email = params[:email]
		@invite = Invite.find(params[:id])
		@invite.decline(@email)
		Log.create(type: "Invite", action: "decline", data: {id: @invite.id}, ip: request.ip)
	end

	def report
		@invite = Invite.find(params[:id])
		@invite.add_report_count
		Log.create(type: "Invite", action: "report", data: {id: @invite.id}, ip: request.ip)
	end

	def create_report
		@invite = Invite.find(params[:id])
		@invite.add_report_text(report_params[:reports])
		Log.create(type: "Invite", action: "create_report", data: {id: @invite.id, report_text: report_params[:reports]}, ip: request.ip)
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
	        params.require(:invite).permit(:name,:start_date,:end_date,:description,:allow_others,:address)
	    end

	    def parse_params
	    	return invite_params if invite_params.has_key? "start_date"

	    	ip = invite_params
	    	start_date = ip["start_date(1i)"] + "-" + ip["start_date(2i)"] + "-" + ip["start_date(3i)"] + "-" + ip["start_date(4i)"] + "-" + ip["start_date(5i)"]
	    	end_date = ip["end_date(1i)"] + "-" + ip["end_date(2i)"] + "-" + ip["end_date(3i)"] + "-" + ip["end_date(4i)"] + "-" + ip["end_date(5i)"]

	    	ip = delete_params ip
	    	
	    	ip["start_date"] = start_date
	    	ip["end_date"] = end_date
	    	
	    	return ip
	    end

	    def delete_params ip
	    	ip.delete("start_date(1i)")
	    	ip.delete("start_date(2i)")
	    	ip.delete("start_date(3i)")
	    	ip.delete("start_date(4i)")
	    	ip.delete("start_date(5i)")
	    	ip.delete("end_date(1i)")
	    	ip.delete("end_date(2i)")
	    	ip.delete("end_date(3i)")
	    	ip.delete("end_date(4i)")
	    	ip.delete("end_date(5i)")
	    	return ip
	    end

end
