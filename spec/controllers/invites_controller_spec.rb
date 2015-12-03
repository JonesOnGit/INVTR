# invites_controller_spec.rb
require 'rails_helper'
require 'spec_helper'

describe InvitesController do 
	describe "GET #new" do
    # it "assigns a new Invite to @invite" do
    # 	 assigns(:invite).should eq(Invite.new)
    # end
    it "renders the :new view" do
      get :new
      response.should render_template :new
    end
  end

  describe "GET #show" do
    it "assigns a new Invite to @invite" do
      invite = FactoryGirl.create(:invite)
      get :show, id: invite
    	assigns(:invite).should eq(invite)
    end

    it "renders the :show view" do
      invite = FactoryGirl.create(:invite)
      get :show, id: invite.id
      response.should render_template :show
    end
  end

  describe "GET #edit" do
    it "renders an existing Invite to @invite" do 
      invite = FactoryGirl.create(:invite)
      get :edit, id: invite
      assigns(:invite).should eq(invite)
    end 

    it "renders the :edit view" do 
      invite = FactoryGirl.create(:invite)
      get :edit, id: invite.id
      response.should render_template :edit
    end 
  end

  describe "POST #create" do 
    it "increments the Invite database count by 1" do
      expect {
        post :create, invite: FactoryGirl.attributes_for(:invite)
      }.to change(Invite, :count).by(1)
    end
  end 

  describe "PUT #update" do 
    it "locates the correct invite" do
      invite = FactoryGirl.create(:invite)
      put :update, id: invite.id, invite: FactoryGirl.attributes_for(:invite)
      assigns(:invite).should eq(invite)  
    end

    it "changes the invite's attributes" do
      invite = FactoryGirl.create(:invite)
      put :update, id: invite.id, invite: FactoryGirl.attributes_for(:invite, name: "My Invite Name")
      invite.reload
      invite.name.should eq("My Invite Name")
    end
  end

  describe "DELETE #destroy" do
    it "deletes the invite" do
      invite = FactoryGirl.create(:invite)
      expect{
            delete :destroy, id: invite        
          }.to change(Invite,:count).by(-1)
    end

    # it "redirects to the home page" do
    # end
  end
end 