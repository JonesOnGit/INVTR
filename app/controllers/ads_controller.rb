class AdsController < ApplicationController
	before_action :authenticate_user!, except: [:session_image]
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

	def session_image
		# check if session image exists
		# if not, load random image and save as session image
		# set sesstion to expire in one hour
		# log which add was used
		if session[:image].nil?
			ad = Ad.where(active: true).where({'start_date' => {'$lt' => DateTime.now}}).where({'end_date' => {'$gt' => DateTime.now}}).offset(rand(Ad.count)).first
			session[:image] = ad.avatar.url
			begin
				f = open(session[:image])
			rescue
				# f.open("'http://s3.amazonaws.com/invtr/ads/avatars/56a1/03e2/dfee/1b00/0300/0000/original/IMAGE_SP.jpg?1453392866'")
			end
			send_file f, :type => 'image/jpeg', :disposition => 'inline'
			return
		else
			f = open(session[:image])
			send_file f, :type => 'image/jpeg', :disposition => 'inline'
			return
		end
	end

	
	def ad_params
	    params.require(:ad).permit(:name,:start_date,:end_date,:desc,:active,:avatar)
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
