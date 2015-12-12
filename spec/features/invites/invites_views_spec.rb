# invites_views_spec.rb

require 'rails_helper'

feature "Invites views" do
    background do
        @invite = FactoryGirl.create(:invite)
    end

    scenario "Ensure that #show displays an Invite's name" do
        visit invite_path(@invite)
        expect(page).to have_content "#{@invite.name}"
    end

    scenario "Visitor creates a new Invite" do
   			visit root_path

		    within("#new_invite") do
            fill_in "Name", :with => "Invite Name"
            fill_in "Description", :with => "Description text"
            fill_in "Start date", :with => "12-11-15"
            fill_in "End date", :with => "12-12-15"
            click_button "Create Invite"
        end
        expect(page).to have_content "Invite Name"
    end

    scenario "User edits an existing Invite" do
    	  invite = FactoryGirl.create(:invite)
   			visit edit_invite_path(invite)
		    within(".edit_invite") do
            fill_in "Name", :with => "Invite Name"
            fill_in "Description", :with => "Description text"
            fill_in "Start date", :with => "12-11-15"
            fill_in "End date", :with => "12-12-15"
            click_button "Update Invite"
        end
        expect(page).to have_content "Invite Name"
    end
end
# =================
# feature "Invites views" do
#     background do
#     end

#     scenario "" do
#     end
# end