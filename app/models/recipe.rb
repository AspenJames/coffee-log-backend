class Recipe < ApplicationRecord
  belongs_to :brew_method
  belongs_to :coffee
  belongs_to :entry
end
