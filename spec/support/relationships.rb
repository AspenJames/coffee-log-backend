RSpec.shared_examples "a belongs_to relationship" do
  ##
  # Describes a belongs_to relationship
  # described     => instance of class provided for testing
  # relation_name => symbol passed to belongs_to in model file
  # reflexive     => symbol describing reflexive method;
  #                  optional, defaults to has_many form

  before(:all) do
    # ensure required values are set
    raise DescribedObjectRequired if !respond_to?(:described)
    raise RelationMethodNameRequired if !respond_to?(:relation_name)
  end

  it "responds to #relation_name and does not return a collection" do
    expect(described.respond_to?(relation_name)).to be true
    expect(described.send(relation_name)).not_to be_a_kind_of(ActiveRecord::Associations::CollectionProxy)
  end

  it "belongs to the given relation" do
    rel = described.send(relation_name)
    relation_class = get_class_constant(relation_name)
    described_class_sym_plural = get_class_sym_plural(described_class)
    reflex = respond_to?(:reflexive) ? reflexive : described_class_sym_plural

    expect(rel).to be_a_kind_of(relation_class)
    reflexive_relation = rel.send(reflex)
    if reflexive_relation.respond_to?(:include)
      expect(reflexive_relation).to include(described)
    else
      expect(reflexive_relation).to eq described
    end
  end
end

RSpec.shared_examples "a has_many relationship" do
  ##
  # Describes a has_many relationship
  # described     => instance of class provided for testing
  # relation_name => symbol passed to has_many in model file
  # reflexive     => symbol describing reflexive method;
  #                  optional, defaults to belongs_to form

  before(:all) do
    # ensure required values are set
    raise DescribedObjectRequired if !respond_to?(:described)
    raise RelationMethodNameRequired if !respond_to?(:relation_name)
  end

  ##
  # Returns class constant of relation
  def relation_class
    get_class_constant(relation_name)
  end

  it "responds to #relation_name and returns a collection" do
    expect(described.respond_to?(relation_name)).to be true
    expect(described.send(relation_name)).to be_a_kind_of(ActiveRecord::Associations::CollectionProxy)
  end

  it "initially has an empty relation set" do
    expect(described.send(relation_name).length).to eq 0
  end

  it "can return a single relation" do
    relation_class_sym = get_singular_symbol(relation_name)
    described_class_sym = get_class_sym_singular(described_class)
    reflex = respond_to?(:reflexive) ? reflexive : described_class_sym

    opts = {}
    opts[described_class_sym] = described

    rel = create(relation_class_sym, opts)
    related = described.send(relation_name)

    expect(related.length).to eq 1
    expect(related[0]).to eq rel
    expect(related[0]).to be_a_kind_of(relation_class)
    if related[0].respond_to?(:include)
      expect(related[0].send(reflex)).to include(described)
    else
      expect(related[0].send(reflex)).to eq described
    end
  end

  it "can return multiple relations" do
    relation_class_sym = get_singular_symbol(relation_name)
    described_class_sym = get_class_sym_singular(described_class)
    reflex = respond_to?(:reflexive) ? reflexive : described_class_sym

    opts = {}
    opts[described_class_sym] = described

    5.times { create(relation_class_sym, opts) }

    related = described.send(relation_name)
    expect(related.length).to eq 5
    related.each do |r|
      expect(r).to be_a_kind_of(relation_class)
      reflexive_relation = r.send(reflex)
      if reflexive_relation.respond_to?(:include)
        expect(reflexive_relation).to include(described)
      else
        expect(reflexive_relation).to eq described
      end
    end
  end
end

RSpec.shared_examples "a has_many, through relationship" do
  ##
  # Describes a has_many, through: relationship
  # described     => instance of class provided for testing
  # relation_name => symbol passed to has_many in model file
  # through_name  => symbol passed to through: in model file
  # reflexive     => symbol describing reflexive method;
  #                  optional, defaults to has_many form

  before(:all) do
    # ensure required values are set
    raise DescribedObjectRequired if !respond_to?(:described)
    raise RelationMethodNameRequired if !respond_to?(:relation_name)
    raise ThroughNameRequired if !respond_to?(:through_name)
  end

  ##
  # Returns class constant of relation
  def relation_class
    get_class_constant(relation_name)
  end

  ##
  # Returns class constant of through: relation
  def through_class
    get_class_constant(through_name)
  end

  it "responds to #relation_name and returns a collection" do
    expect(described.respond_to?(relation_name)).to be true
    expect(described.send(relation_name)).to be_a_kind_of(ActiveRecord::Associations::CollectionProxy)
  end

  it "initially has an empty relation set" do
    expect(described.send(relation_name).length).to eq 0
  end

  it "can return a single relation" do
    described_class_sym = get_class_sym_singular(described_class)
    described_class_sym_plural = get_class_sym_plural(described_class)
    through_sym = get_singular_symbol(through_name)
    rel_sym = get_singular_symbol(relation_name)
    reflex = respond_to?(:reflexive) ? reflexive : described_class_sym_plural

    through_opt = {}
    through_opt[described_class_sym] = described

    rel_opt = {}
    through_relation = create(through_sym, through_opt)
    rel_opt[through_sym] = through_relation

    begin
      rel = create(rel_sym, rel_opt)
    rescue Exception => e
      rel_opt = {}
      rel_opt[get_plural_symbol(through_sym)] = [through_relation]
      rel = create(rel_sym, rel_opt)
    end


    related = described.send(relation_name)
    expect(related.length).to eq 1
    expect(related.first).to eq rel
    if reflex
      reflexive_relation = rel.send(reflex)
      if reflexive_relation.respond_to?(:include)
        expect(reflexive_relation).to include(described)
      else
        expect(reflexive_relation).to eq described
      end
    end
  end

  it "can return multiple relations" do
    described_class_sym = get_class_sym_singular(described_class)
    described_class_sym_plural = get_class_sym_plural(described_class)
    through_sym = get_singular_symbol(through_name)
    rel_sym = get_singular_symbol(relation_name)
    reflex = respond_to?(:reflexive) ? reflexive : described_class_sym_plural

    through_opt = {}
    through_opt[described_class_sym] = described

    5.times do
      rel_opt = {}
      through_relation = create(through_sym, through_opt)
      begin
        rel_opt[through_sym] = through_relation
        create(rel_sym, rel_opt)
      rescue
        rel_opt = {}
        rel_opt[get_plural_symbol(through_sym)] = [through_relation]
      end
    end

    related = described.send(relation_name)
    expect(related.length).to eq 5
    related.each do |r|
      expect(r).to be_a_kind_of(relation_class)
      if reflex
        reflexive_relation = r.send(reflex)
        if reflexive_relation.respond_to?(:include)
          expect(reflexive_relation).to include(described)
        else
          expect(reflexive_relation).to eq described
        end
      end
    end
  end
end

RSpec.shared_examples "a has_one relationship" do
  ##
  # Describes a has_one relationship
  # described     => instance of class provided for testing
  # relation_name => symbol passed to has_many in model file
  # reflexive     => symbol describing reflexive method;
  #                  optional, defaults to belongs_to form

  before(:all) do
    # ensure required values are set
    raise DescribedObjectRequired if !respond_to?(:described)
    raise RelationMethodNameRequired if !respond_to?(:relation_name)
  end

  ##
  # Returns class constant of relation
  def relation_class
    get_class_constant(relation_name)
  end

  it "responds to #relation_name and does not return a collection" do
    expect(described.respond_to?(relation_name)).to be true
    expect(described.send(relation_name)).not_to be_a_kind_of(ActiveRecord::Associations::CollectionProxy)
  end

  it "initially sets relation to nil" do
    expect(described.send(relation_name)).to be nil
  end

  it "can return a single related instance" do
    relation_class_sym = get_singular_symbol(relation_name)
    described_class_sym = get_class_sym_singular(described_class)
    reflex = respond_to?(:reflexive) ? reflexive : described_class_sym

    opts = {}
    opts[described_class_sym] = described

    rel = create(relation_class_sym, opts)
    related = described.send(relation_name)

    expect(related).to be_a_kind_of(relation_class)
    expect(related).to eq rel
    reflexive_relation = related.send(reflex)
    if reflexive_relation.respond_to?(:include)
      expect(reflexive_relation).to include(described)
    else
      expect(reflexive_relation).to eq described
    end
  end
end

RSpec.shared_examples "a has_one, through: relationship" do
  ##
  # Describes a has_one, through relationship
  # described     => instance of class provided for testing
  # relation_name => symbol passed to belongs_to in model file
  # through_name  => symbol passed to through: in model file
  # reflexive     => symbol describing reflexive method;
  #                  optional, defaults to belongs_to form

  before(:all) do
    # ensure required values are set
    raise DescribedObjectRequired if !respond_to?(:described)
    raise RelationMethodNameRequired if !respond_to?(:relation_name)
    raise ThroughNameRequired if !respond_to?(:through_name)
  end

  ##
  # Returns class constant of relation
  def relation_class
    get_class_constant(relation_name)
  end

  ##
  # Returns class constant of through: relation
  def through_class
    get_class_constant(through_name)
  end

  it "responds to #relation_name and does not return a collection" do
    expect(described.respond_to?(relation_name)).to be true
    expect(described.send(relation_name)).not_to be_a_kind_of(ActiveRecord::Associations::CollectionProxy)
  end

  it "initially has relation set to nil" do
    expect(described.send(relation_name)).to be nil
  end

  it "can return a single related instance" do
    described_class_sym = get_class_sym_singular(described_class)
    through_sym = get_singular_symbol(through_name)
    reflex = respond_to(:reflexive) ? reflexive : described_class_sym

    through_opt = {}
    through_opt[described_class_sym] = described

    through = create(through_sym, through_opt)
    rel = through.send(relation_name)

    related = described.send(relation_name)
    expect(related).to be_a_kind_of(relation_class)
    expect(related).to eq rel
    reflexive_relation = rel.send(reflex)
    if reflexive_relation.respond_to?(:include)
      expect(reflexive_relation).to include(described)
    else
      expect(reflexive_relation).to eq described
    end
  end
end

class DescribedObjectRequired < StandardError
  DEFAULT_MSG = <<-TEXT
  ":described" must be defined.
    => Please supply the instance with which to test
    => ex. a Blog has_many Posts; @blog = Blog.create
    => let(:described) { @blog }
  TEXT
  def initialize(msg=DEFAULT_MSG); super(msg); end
end

class RelationMethodNameRequired < StandardError
  DEFAULT_MSG = <<-TEXT
  ":relation_name" must be defined.
    => Please supply the symbol signifying the relationship in the model file
    => ex. class Blog; has_many :posts; end
    => let(:relation_name) { :posts }
  TEXT
  def initialize(msg=DEFAULT_MSG); super(msg); end
end

class ThroughNameRequired < StandardError
  DEFAULT_MSG = <<-TEXT
  ":through_name" must be defined.
    => Please supply the symbol passed to through: in the model file
    => ex. class Blog; has_many :comments, through: :posts; end
    => let(:relation_name) { :comments }
    => let(:through_name) { :posts }
  TEXT
  def initialize(msg=DEFAULT_MSG); super(msg); end
end

##
# Returns a singular class symbol from a class constant
# get_class_sym_singular(Coffee) #=> :coffee
def get_class_sym_singular(klass)
  klass.name.tableize.singularize.to_sym
end

##
# Returns a plural class symbol from a class constant
# get_class_sym_plural(Coffee) #=> :coffees
def get_class_sym_plural(klass)
  klass.name.tableize.to_sym
end

##
# Returns a singular symbol rom a plural
# get_singular_symbol(:coffees) #=> :coffee
def get_singular_symbol(sym)
  sym.to_s.singularize.to_sym
end

##
# Returns a plural symbol from a singular
# get_plural_symbol(:coffee) #=> :coffees
def get_plural_symbol(sym)
  sym.to_s.pluralize.to_sym
end

##
# Returns a class constant from a symbol
# get_class_constant(:coffee) #=> Coffee
def get_class_constant(sym)
  sym.to_s.singularize.camelize.constantize
end
