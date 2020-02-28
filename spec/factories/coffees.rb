FactoryBot.define do
  sequence :coffee_name do |n|
    "CoffeeOrigin#{n}"
  end

  factory :coffee do
    origin { generate(:coffee_name) }
    roast_date { 10.days.ago }
    price { 2500 }
    roaster
  end
end
