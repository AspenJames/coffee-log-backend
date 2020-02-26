class BrewMethod < ApplicationRecord
  has_many :recipes
  has_many :coffees, :through => :recipes
end
