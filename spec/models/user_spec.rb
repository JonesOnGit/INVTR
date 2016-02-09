require 'rails_helper'
require 'spec_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it { should validate_presence_of(:role) }
  it { should validate_length_of(:fullname) }
  it { should validate_length_of(:role) }
  it { should validate_length_of(:city) }
  it { should validate_length_of(:state_or_region) }
  it { should validate_length_of(:country) }

end
