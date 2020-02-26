class Coffee < ApplicationRecord
  belongs_to :roaster
  has_many :recipes
end
