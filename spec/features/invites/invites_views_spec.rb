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
end
# =================
# feature "Invites views" do
#     background do
#     end

#     scenario "" do
#     end
# end