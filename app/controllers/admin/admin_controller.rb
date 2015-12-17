module Admin
	class AdminController < ApplicationController
		before_action :authenticate_user!
		def index
			@user = current_user
			@invite_count = Invite.count
			@accepted_count = Log.where(type: "accept").count
			@rejected_count = Log.where(type: "decline").count
			@report_count = Log.where(type: "report").count
			@written_report_count = Log.where(type: "create_report").count
			# @sorted_reports = Invite.where(:report_count.gt => 0).order_by(report_count: "desc")
		end
	end
end
