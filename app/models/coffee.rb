class Coffee < ApplicationRecord
  belongs_to :roaster
  has_many :recipes
  has_many :entries, :through => :recipes

  validates :origin, :roast_date, presence: true
  make_immutable(:origin)
  make_immutable(:roast_date)

end
