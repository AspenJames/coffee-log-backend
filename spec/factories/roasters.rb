FactoryBot.define do
  sequence :roaster_name do |n|
    "RoasterName#{n}"
  end

  factory :roaster do
    name { generate(:roaster_name) }
  end
end
