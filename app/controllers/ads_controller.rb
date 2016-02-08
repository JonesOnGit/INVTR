class AdsController < ApplicationController
	before_action :authenticate_user!, except: [:session_image, :click]

	def click
		Log.create(type: "Ad", action: "click", data: session[:ad].to_json, ip: request.ip, ad_id: session[:ad]["_id"]["$oid"], ad_size: session[:type])
		render status: 200, json: @controller.to_json
	end
	def create
		@ad = Ad.new(parse_params) 
		if @ad.save
			Log.create(type: "Ad", action: "save", data: @ad.to_json, ip: request.ip, invite_id: @ad.id)
		    flash[:notice] = "Ad #{@ad.name} saved."
		 	redirect_to admin_root_path
		else
		    flash[:alert] = "Ad #{@ad.name} not saved."
		    redirect_to admin_root_path
		end
	end

	def edit
		@ad = Ad.find(params[:id])
	end

	def update
		@ad = Ad.find(params[:id])
		if @ad.update(parse_params)
		  flash[:notice] = "#{@ad.name} updated"	
		  redirect_to admin_root_path
		else
		  flash[:notice] = "#{@ad.name} not updated"
		  redirect_to admin_root_path
		end
	end

	def destroy
		@ad = Ad.find(params[:id])
		@ad.delete
		redirect_to admin_root_path
	end

	def ad_params
	    params.require(:ad).permit(:name,:start_date,:end_date,:desc,:redirect_url,:desktop_location, :mobile_location)
	end

	def parse_params
		return ad_params if ad_params.has_key? "start_date"

		ip = ad_params
		start_date = ip["start_date(1i)"] + "-" + ip["start_date(2i)"] + "-" + ip["start_date(3i)"]
		end_date = ip["end_date(1i)"] + "-" + ip["end_date(2i)"] + "-" + ip["end_date(3i)"]

		ip = delete_params ip
		
		ip["start_date"] = start_date
		ip["end_date"] = end_date
		
		return ip
	end

	def delete_params ip
		ip.delete("start_date(1i)")
		ip.delete("start_date(2i)")
		ip.delete("start_date(3i)")
		ip.delete("end_date(1i)")
		ip.delete("end_date(2i)")
		ip.delete("end_date(3i)")
		return ip
	end
end
