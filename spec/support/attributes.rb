RSpec.shared_examples "a required attribute" do
  # attribute_name => symbol representing the required attribute
  before(:all) do
    raise AttributeNameRequired if !respond_to?(:attribute_name)
  end

  def described_class_sym
    described_class.name.downcase.to_sym
  end

  it "is invalid without attribute supplied" do
    attrs = attributes_for(described_class_sym)
    incomplete_attrs = attrs.except(attribute_name)
    described = described_class.new(incomplete_attrs)
    expect(described.valid?).to be false
    expect(described.errors.messages.keys).to include(attribute_name)
    expect(described.errors.messages[attribute_name]).to include("can't be blank")
  end
end

RSpec.shared_examples "an immutable attribute" do
  # attribute_name => symbol representing the immutable attribute
  before(:all) do
    raise AttributeNameRequired if !respond_to?(:attribute_name)
  end

  def described_class_sym
    described_class.name.downcase.to_sym
  end

  it "cannot be updated once set" do
    described = create(described_class_sym)
    orig_val = described.send(attribute_name)
    update_arg = {}
    update_arg[attribute_name] = ""
    expect{described.update(update_arg)}.to raise_exception(Exceptions::ImmutableAttributeError)
    expect(described.send(attribute_name)).to eq orig_val
  end
end

RSpec.shared_examples "a mutable attribute" do
  # attribute_name => symbol representing the mutable attribute
  # update_value => value to update, default to "New value"
  before(:all) do
    raise AttributeNameRequired if !respond_to?(:attribute_name)
  end

  def described_class_sym
    described_class.name.downcase.to_sym
  end

  it "can be updated once set" do
    described = create(described_class_sym)
    orig_val = described.send(attribute_name)

    update_arg = {}
    update_arg[attribute_name] = update_value
    described.update(update_arg)
    expect(described.valid?).to be true

    new_val = described.send(attribute_name)
    expect(orig_val).not_to eq new_val
  end
end

class AttributeNameRequired < StandardError
  DEFAULT_MSG = <<~TEXT
  ":attribute_name" must be defined.
    => Please supply the attribute name as a symbol
    => ex. class Blog; validates :title, presence: true; end
    => let(:attribute_name) { :title }
  TEXT
  def initialize(msg=DEFAULT_MSG)
    super(msg)
  end
end