# invites_controller_spec.rb
require 'rails_helper'
require 'spec_helper'

describe InvitesController do 
	describe "GET #new" do
    # it "assigns a new Invite to @invite" do
    # 	 assigns(:invite).should eq([Invite.new])
    # 	end
    it "renders the :new view" do
      get :new
      response.should render_template :new
    end
  end
  	describe "GET #show" do
    # it "assigns a new Invite to @invite" do
    # 	 assigns(:invite).should eq([Invite.new])
    # 	end
    it "renders the :show view" do
      get :show, id:1
      response.should render_template :show
    end
  end
end 