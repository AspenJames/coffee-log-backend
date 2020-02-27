require 'rails_helper'

RSpec.describe Roaster, type: :model do

  context "Initialization:" do
    it "is invalid without a name" do
      r = Roaster.create
      expect(r.valid?).to be false
      expect(r.errors.messages.keys).to include(:name)
    end

    it "is valid with a name" do
      r = Roaster.create(name: "Stumptown")
      expect(r).to be_valid
    end
  end

  context "Attributes:" do
    before :all do
      @roaster = Roaster.create(name: "Stumptown")
    end

    it "can return its name" do
      expect(@roaster.name).to eq("Stumptown")
    end

    it "cannot modify its name once set" do
      expect{@roaster.name = "Broadcast"}.to raise_exception(Exceptions::ImmutableAttributeError)
      expect(@roaster.name).to eq("Stumptown")
    end
  end

  context "Relationships:" do
    describe "Coffee:" do
      before :each do
        @roaster = Roaster.create(name: "Broadcast Coffee #{Time.now}")
      end

      it "can return a collection of coffees" do
        expect(@roaster.respond_to?(:coffees)).to be true
        expect(@roaster.coffees).to be_a_kind_of(ActiveRecord::Associations::CollectionProxy)
      end

      it "starts with no associated coffees" do
        expect(@roaster.coffees.length).to eq 0
      end

      it "returns assc. coffee after creation" do
        c = Coffee.create(
          origin: "Java Garut",
          roast_date: Date.new,
          price: 2500,
          roaster: @roaster
        )
        expect(@roaster.coffees.length).to eq 1
        expect(@roaster.coffees.first).to eq c
        expect(@roaster.coffees.first.roaster).to eq @roaster
      end

      it "can return multiple coffees" do
        5.times do |i|
          Coffee.create(
            origin: "#{i}Colombia",
            roast_date: Date.new,
            price: 2000,
            roaster: @roaster
          )
        end

        expect(@roaster.coffees.length).to eq 5

        @roaster.coffees.each do |c|
          expect(c.class).to be Coffee
          expect(c.roaster).to eq @roaster
        end
      end
    end
  end
end
