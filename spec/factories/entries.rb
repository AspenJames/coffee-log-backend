FactoryBot.define do
  sequence :entry_date do |n|
    Date.parse("1920-01-01") + n.days
  end

  factory :entry do
    date { generate(:entry_date) }
    description { "Veggies es bonus vobis, proinde vos postulo essum magis kohlrabi welsh onion daikon amaranth tatsoi tomatillo melon azuki bean garlic." }
    rating { 3 }
  end
end
