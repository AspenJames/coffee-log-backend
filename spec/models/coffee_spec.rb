require 'rails_helper'

RSpec.describe Coffee, type: :model do
  context "Attributes:" do
    describe "origin" do
      it_behaves_like "a required attribute" do
        let(:attribute_name) { :origin }
      end

      it_behaves_like "an immutable attribute" do
        let(:attribute_name) { :origin }
      end
    end

    describe "roast_date" do
      it_behaves_like "a required attribute" do
        let(:attribute_name) { :roast_date }
      end

      it_behaves_like "an immutable attribute" do
        let(:attribute_name) { :roast_date }
      end
    end

    describe "price" do
      it_behaves_like "an optional attribute" do
        let(:attribute_name) { :price }
      end

      it_behaves_like "a mutable attribute" do
        let(:attribute_name) { :price }
        let(:update_value) { 3500 }
      end
    end
  end

  context "Relationships:" do
    describe "Roaster:" do
      it_behaves_like "a belongs_to relationship" do
        let(:described) { create(:coffee) }
        let(:relation_name) { :roaster }
      end
    end

    describe "Recipes:" do
      it_behaves_like "a has_many relationship" do
        let(:described) { create(:coffee) }
        let(:relation_name) { :recipes }
      end
    end

    describe "Entries:" do
      it_behaves_like "a has_many, through relationship" do
        let(:described) { create(:coffee) }
        let(:relation_name) { :entries }
        let(:through_name) { :recipes }
      end
    end
  end
end
