require 'rails_helper'
require 'spec_helper'


describe UsersController do 

	describe 'GET #new' do 
		it 'renders the :new view' do
		get :new
      expect(response).to render_template :new
		end 
	end

  describe "GET #show" do
    it "assigns a new User to @user" do
      user = FactoryGirl.create(:user)
      get :show, id: user
    	expect(assigns(:user)).to eq(user)
    end
   end



end 



