require 'rails_helper'
require 'spec_helper'
require 'devise'


RSpec.describe UsersController, type: :controller do

	describe UsersController do 
		describe "GET #new" do
			
    it "renders the :new view" do
      get :new
      expect(response).to render_template :new
    end
  end








	end 


end
