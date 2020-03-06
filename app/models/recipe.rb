class Recipe < ApplicationRecord
  belongs_to :brew_method
  belongs_to :coffee
  belongs_to :entry

  validates :time, format: { with: /\A(\d+)(:)([0-5]{1}[0-9]{1})\z/,
                             message: "must match the format mm:ss" },
                             allow_nil: true
end
