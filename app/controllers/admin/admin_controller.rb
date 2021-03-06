module Admin
	class AdminController < ApplicationController
		before_action :authenticate_user!
		layout 'layouts/admin'
		def index
			@ad = Ad.new
			@ads = Ad.all
			@user = current_user
			@invite_count = Invite.count
			@accepted_count = Log.where(action: "accept").count
			@rejected_count = Log.where(action: "decline").count
			@report_count = Log.where(action: "report").count
			@written_report_count = Log.where(action: "create_report").count
			@sorted_reports = Invite.where(:report_count.gt => 0).where(active: true).order_by(report_count: "desc")
			@deactivated_count = Invite.where(active: false).count
			@logs = Log.all
		end
		def stats
			@ad = Ad.find(params[:id])
			stats = Log.where(ad_id: @ad.id, action: "show")
			clicks = Log.where(ad_id: @ad.id, action: "click")
			stats_hash = {}
			stats.each do |stat|
				date = stat.created_at.to_s[0..9]
				if stats_hash.key? date
					stats_hash[date]["count"] += 1
					stats_hash[date][stat.ad_size] += 1
				else
					stats_hash[date] = {}
					stats_hash[date]["count"] =  1
					stats_hash[date]["mobile"] = 0
					stats_hash[date]["desktop"] = 0
					stats_hash[date][stat.ad_size] = 1
				end
			end
			@stats_hash = stats_hash


			clicks_hash = {}
			clicks.each do |click|
				date = click.created_at.to_s[0..9]
				if clicks_hash.key? date
					clicks_hash[date]["count"] += 1
					clicks_hash[date][click.ad_size] += 1
				else
					clicks_hash[date] = {}
					clicks_hash[date]["count"] =  1
					clicks_hash[date]["mobile"] = 0
					clicks_hash[date]["desktop"] = 0
					clicks_hash[date][click.ad_size] = 1
				end
			end
			@clicks_hash = clicks_hash
			@user = current_user
		end
	end
end
