class Entry < ApplicationRecord
  has_one :recipe
  has_one :coffee, :through => :recipe

  validates :date, :description, :rating, presence: true
  make_immutable(:date)
end
