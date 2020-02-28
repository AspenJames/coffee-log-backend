class Roaster < ApplicationRecord
  has_many :coffees

  validates :name, presence: true

  make_immutable(:name)

end
