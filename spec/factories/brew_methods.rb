FactoryBot.define do
  sequence :brew_method_name do |n|
    "BrewMethod#{n}"
  end

  factory :brew_method do
    name { generate(:brew_method_name) }
  end
end
