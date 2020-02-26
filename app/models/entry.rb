class Entry < ApplicationRecord
  has_one :recipe
  has_one :coffee, :through => :recipe
end
