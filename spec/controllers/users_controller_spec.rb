require 'rails_helper'
require 'spec_helper'

RSpec.describe UsersController, type: :controller do

	describe UsersController do 

	describe 'GET #new' do 
		it 'renders the :new view'
		get :new
      expect(response).to render_template :new
	end 

	end 


end
