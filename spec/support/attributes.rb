RSpec.shared_examples "a required attribute" do
  ##
  # Describes an attribute required for model instance creation
  # attribute_name => symbol representing the required attribute

  before(:all) do
    # ensure required value is set
    raise AttributeNameRequired if !respond_to?(:attribute_name)
  end

  it "is invalid without attribute supplied" do
    attrs = attributes_for(described_class_sym)
    update_obj = {}
    update_obj[attribute_name] = nil
    attrs.merge!(update_obj)
    expect{
      create(described_class_sym, attrs)
    }.to raise_exception(ActiveRecord::RecordInvalid)
  end
end

RSpec.shared_examples "an optional attribute" do
  ##
  # Describes an attribute that may be omitted from model creation
  # attribute_name => symbol representing the optional attribute

  before(:all) do
    # ensure required value is set
    raise AttributeNameRequired if !respond_to?(:attribute_name)
  end

  it "can be omitted from the creation args" do
    attrs = attributes_for(described_class_sym)
    update_obj = {}
    update_obj[attribute_name] = nil
    attrs.merge!(update_obj)
    described = create(described_class_sym, attrs)
    expect(described.valid?).to be true
  end
end

RSpec.shared_examples "an immutable attribute" do
  ##
  # Describes an attribute that cannot be changed once set
  # attribute_name => symbol representing the immutable attribute

  before(:all) do
    # ensure required value is set
    raise AttributeNameRequired if !respond_to?(:attribute_name)
  end

  it "cannot be updated once set" do
    described = create(described_class_sym)
    orig_val = described.send(attribute_name)
    update_arg = {}
    # The type of value for update_arg does not matter
    # since we are expecting an exception to be thrown
    update_arg[attribute_name] = ""
    expect{described.update(update_arg)}.to raise_exception(Exceptions::ImmutableAttributeError)
    expect(described.send(attribute_name)).to eq orig_val
  end
end

RSpec.shared_examples "a mutable attribute" do
  ##
  # Describes an attribute that may be updated
  # attribute_name => symbol representing the mutable attribute
  # update_value => value to update; optional, defaults to "UpdateValue"

  before(:all) do
    # ensure required value is set
    raise AttributeNameRequired if !respond_to?(:attribute_name)
  end

  it "can be updated once set" do
    described = create(described_class_sym)
    orig_val = described.send(attribute_name)

    update_val = respond_to?(:update_value) ? update_value : "UpdateValue"

    update_arg = {}
    update_arg[attribute_name] = update_val
    described.update(update_arg)
    expect(described.valid?).to be true

    new_val = described.send(attribute_name)
    expect(orig_val).not_to eq new_val
    expect(new_val).to eq update_val
  end
end

class AttributeNameRequired < StandardError
  DEFAULT_MSG = <<~TEXT
  ":attribute_name" must be defined.
    => Please supply the attribute name as a symbol
    => ex. class Blog; validates :title, presence: true; end
    => let(:attribute_name) { :title }
  TEXT
  def initialize(msg=DEFAULT_MSG); super(msg); end
end

##
# Returns a symbol representing the described class
# e.g. within RSpec.describe Coffee:
# described_class_sym #=> :coffee
def described_class_sym
  described_class.name.underscore.to_sym
end
