FactoryGirl.define do
	
  factory :user do
    email { Faker::Internet.email }
    password "password"
    encrypted_password "password"
    role "role"
  end

end
