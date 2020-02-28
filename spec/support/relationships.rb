RSpec.shared_examples "a belongs_to relationship" do
  # described     => instance of class provided for testing
  # relation_name => symbol passed to belongs_to in model file
  before(:all) do
    raise DescribedObjectRequired if !respond_to?(:described)
    raise RelationMethodNameRequired if !respond_to?(:relation_name)
  end

  it "responds to #relation_name and returns an instance" do
    expect(described.respond_to?(relation_name)).to be true
    expect(described.send(relation_name)).not_to be_a_kind_of(ActiveRecord::Associations::CollectionProxy)
  end

  it "belongs to the given relation" do
    rel = described.send(relation_name)
    relation_class = relation_name.to_s.capitalize.constantize
    described_class_sym_plural = described_class.name.downcase.pluralize.to_sym
    expect(rel).to be_a_kind_of(relation_class)
    expect(rel.send(described_class_sym_plural)).to include(described)
  end
end

RSpec.shared_examples "a has_many relationship" do
  # described     => instance of class provided for testing
  # relation_name => symbol passed to has_many in model file
  before(:all) do
    raise DescribedObjectRequired if !respond_to?(:described)
    raise RelationMethodNameRequired if !respond_to?(:relation_name)
  end

  def relation_class
    relation_name.to_s.singularize.capitalize.constantize
  end

  it "responds to #relation_name and returns a collection" do
    expect(described.respond_to?(relation_name)).to be true
    expect(described.send(relation_name)).to be_a_kind_of(ActiveRecord::Associations::CollectionProxy)
  end

  it "initially has an empty relation set" do
    expect(described.send(relation_name).length).to eq 0
  end

  it "can return a single relation" do
    relation_class_sym = relation_name.to_s.singularize.to_sym
    described_class_sym = described_class.name.downcase.to_sym

    opts = {}
    opts[described_class_sym] = described

    rel = create(relation_class_sym, opts)
    related = described.send(relation_name)

    expect(related.length).to eq 1
    expect(related[0]).to eq rel
    expect(related[0]).to be_a_kind_of(relation_class)
    expect(related[0].send(described_class_sym)).to eq described
  end

  it "can return multiple relations" do
    relation_class_sym = relation_name.to_s.singularize.to_sym
    described_class_sym = described_class.name.downcase.to_sym

    opts = {}
    opts[described_class_sym] = described

    5.times { create(relation_class_sym, opts) }

    related = described.send(relation_name)
    expect(related.length).to eq 5
    related.each do |r|
      expect(r).to be_a_kind_of(relation_class)
      expect(r.send(described_class_sym)).to eq described
    end
  end
end

RSpec.shared_examples "a has_many, through relationship" do
  # described     => instance of class provided for testing
  # relation_name => symbol passed to has_many in model file
  # through_name  => symbol passed to through: in model file
  before(:all) do
    raise DescribedObjectRequired if !respond_to?(:described)
    raise RelationMethodNameRequired if !respond_to?(:relation_name)
    raise ThroughNameRequired if !respond_to?(:through_name)
  end

  def relation_class
    relation_name.to_s.singularize.capitalize.constantize
  end

  def through_class
    through_name.to_s.singularize.capitalize.constantize
  end

  it "responds to #relation_name and returns a collection" do
    expect(described.respond_to?(relation_name)).to be true
    expect(described.send(relation_name)).to be_a_kind_of(ActiveRecord::Associations::CollectionProxy)
  end

  it "initially has an empty relation set" do
    expect(described.send(relation_name).length).to eq 0
  end

  it "can return a single relation" do
    described_class_sym = described_class.name.downcase.to_sym
    through_sym = through_name.to_s.singularize.to_sym
    rel_sym = relation_name.to_s.singularize.to_sym

    through_opt = {}
    through_opt[described_class_sym] = described

    rel_opt = {}
    rel_opt[through_sym] = create(through_sym, through_opt)

    rel = create(rel_sym, rel_opt)

    related = described.send(relation_name)
    expect(related.length).to eq 1
    expect(related.first).to eq rel
    expect(rel.send(described_class_sym)).to eq described
  end

  it "can return multiple relations" do
    described_class_sym = described_class.name.downcase.to_sym
    through_sym = through_name.to_s.singularize.to_sym
    rel_sym = relation_name.to_s.singularize.to_sym

    through_opt = {}
    through_opt[described_class_sym] = described

    5.times do
      rel_opt = {}
      rel_opt[through_sym] = create(through_sym, through_opt)
      create(rel_sym, rel_opt)
    end

    related = described.send(relation_name)
    expect(related.length).to eq 5
    related.each do |r|
      expect(r).to be_a_kind_of(relation_class)
      expect(r.send(described_class_sym)).to eq described
    end
  end
end

RSpec.shared_examples "a has_one relationship" do
  # described     => instance of class provided for testing
  # relation_name => symbol passed to has_many in model file
  before(:all) do
    raise DescribedObjectRequired if !respond_to?(:described)
    raise RelationMethodNameRequired if !respond_to?(:relation_name)
  end

  def relation_class
    relation_name.to_s.singularize.capitalize.constantize
  end

  it "responds to #relation_name and does not return a collection" do
    expect(described.respond_to?(relation_name)).to be true
    expect(described.send(relation_name)).not_to be_a_kind_of(ActiveRecord::Associations::CollectionProxy)
  end

  it "initially sets relation to nil" do
    expect(described.send(relation_name)).to be nil
  end

  it "can return a single related instance" do
    relation_class_sym = relation_name.to_s.singularize.to_sym
    described_class_sym = described_class.name.downcase.to_sym

    opts = {}
    opts[described_class_sym] = described

    rel = create(relation_class_sym, opts)
    related = described.send(relation_name)

    expect(related).to be_a_kind_of(relation_class)
    expect(related).to eq rel
    expect(related.send(described_class_sym)).to eq described
  end
end

RSpec.shared_examples "a has_one, through: relationship" do
  # described     => instance of class provided for testing
  # relation_name => symbol passed to has_many in model file
  # through_name  => symbol passed to through: in model file
  before(:all) do
    raise DescribedObjectRequired if !respond_to?(:described)
    raise RelationMethodNameRequired if !respond_to?(:relation_name)
    raise ThroughNameRequired if !respond_to?(:through_name)
  end

  def relation_class
    relation_name.to_s.singularize.capitalize.constantize
  end

  def through_class
    through_name.to_s.singularize.capitalize.constantize
  end

  it "responds to #relation_name and does not return a collection" do
    expect(described.respond_to?(relation_name)).to be true
    expect(described.send(relation_name)).not_to be_a_kind_of(ActiveRecord::Associations::CollectionProxy)
  end

  it "initially has an empty relation set" do
    expect(described.send(relation_name)).to be nil
  end

  it "can return a single related instance" do
    described_class_sym = described_class.name.downcase.to_sym
    described_class_sym_plural = described_class.name.downcase.pluralize.to_sym
    through_sym = through_name.to_s.singularize.to_sym

    through_opt = {}
    through_opt[described_class_sym] = described

    through = create(through_sym, through_opt)
    rel = through.send(relation_name)

    related = described.send(relation_name)
    expect(related).to be_a_kind_of(relation_class)
    expect(related).to eq rel
    expect(rel.send(described_class_sym_plural)).to include(described)
  end
end

class DescribedObjectRequired < StandardError
  DEFAULT_MSG = <<-TEXT
  ":described" must be defined.
    => Please supply the instance with which to test
    => ex. a Blog has_many Posts; @blog = Blog.create
    => let(:described) { @blog }
  TEXT
  def initialize(msg=DEFAULT_MSG)
    super(msg)
  end
end

class RelationMethodNameRequired < StandardError
  DEFAULT_MSG = <<-TEXT
  ":relation_name" must be defined.
    => Please supply the symbol signifying the relationship in the model file
    => ex. class Blog; has_many :posts; end
    => let(:relation_name) { :posts }
  TEXT
  def initialize(msg=DEFAULT_MSG)
    super(msg)
  end
end

class ThroughNameRequired < StandardError
  DEFAULT_MSG = <<-TEXT
  ":through_name" must be defined.
    => Please supply the symbol passed to through: in the model file
    => ex. class Blog; has_many :comments, through: :posts; end
    => let(:relation_name) { :comments }
    => let(:through_name) { :posts }
  TEXT
  def initialize(msg=DEFAULT_MSG)
    super(msg)
  end
end