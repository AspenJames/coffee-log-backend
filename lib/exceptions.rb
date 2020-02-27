module Exceptions
  # Raised when we don't want an attribute to be
  # mutable after creation. See models/roaster.rb
  class ImmutableAttributeError < StandardError; end
end