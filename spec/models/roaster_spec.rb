require 'rails_helper'

RSpec.describe Roaster, type: :model do

  context "Initialization:" do
    it "is invalid without a name" do
      r = Roaster.create
      expect(r.valid?).to be false
      expect(r.errors.messages.keys).to include(:name)
    end

    it "is valid with a name" do
      r = create(:roaster)
      expect(r).to be_valid
    end
  end

  context "Attributes:" do
    before :all do
      @roaster = create(:roaster, name: "Stumptown")
    end

    it "can return its name" do
      expect(@roaster.name).to eq("Stumptown")
    end

    it "cannot modify its name once set" do
      expect{@roaster.update(name: "Broadcast")}.to raise_exception(Exceptions::ImmutableAttributeError)
      expect(@roaster.name).to eq("Stumptown")
    end
  end

  context "Relationships:" do
    describe "Coffee:" do
      it_behaves_like "a has_many relationship" do
        let(:described) { create(:roaster) }
        let(:relation_name) { :coffees }
      end
    end
  end
end