class InvitesController < ApplicationController

	def new
		@invite = Invite.new
	end 

	def show
		@invite = Invite.find(params[:id])
	end

	def edit
		@invite = Invite.find(params[:id])
	end

	def create
		@invite = Invite.new(parse_params) 
		if @invite.save
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

    private
	    def invite_params
	        params.require(:invite).permit(:name,:start_date,:end_date,:description,:allow_others)
	    end

	    def parse_params
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
