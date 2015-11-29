require 'rails_helper'
require 'spec_helper'

RSpec.describe Invite, type: :model do
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:description) }
	it { should validate_length_of(:name).is_at_most(150) }
	it { should validate_length_of(:description).is_at_most(1000) }
end