FactoryBot.define do
  factory :coffee do
    origin { "CoffeeOrigin" }
    roast_date { 10.days.ago }
    price { 2500 }
    roaster
  end
end
