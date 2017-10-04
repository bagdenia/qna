FactoryGirl.define do
  factory :atm do
    address { Faker::Lorem.sentence }
    lat { rand(-90..90) }
    lng { rand(-180..180) }
  end
end
