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
		@invite = Invite.new(invite_params) 
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
		if  @invite.update_attributes(invite_params)
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

end
