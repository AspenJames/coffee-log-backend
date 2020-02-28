FactoryBot.define do
  factory :recipe do
    dose { 25 }
    output { 400 }
    time { "4.30" }
    brew_method
    coffee
    entry
  end
end
