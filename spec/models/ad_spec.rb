require 'rails_helper'
require 'spec_helper'

RSpec.describe Ad, type: :model do
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:start_date) }
	it { should validate_presence_of(:end_date) }
	it { should validate_presence_of(:desc) }
	it { should validate_presence_of(:redirect_url) }
end
