class Roaster < ApplicationRecord
  has_many :coffees

  validates :name, presence: true

  def name=(*args)
    if self.name != nil
      raise Exceptions::ImmutableAttributeError
    else
      super
    end
  end
end
