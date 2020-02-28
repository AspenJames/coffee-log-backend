class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.make_immutable(sym)
    define_method("#{sym}=") do |*args|
      if self.send(sym) != nil
        raise Exceptions::ImmutableAttributeError
      else
        super(*args)
      end
    end
  end
end
