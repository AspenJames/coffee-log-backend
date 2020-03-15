require 'rails_helper'

RSpec.describe BrewMethod, type: :model do
  context "Attributes:" do
    describe "name" do
      it_behaves_like "an optional attribute" do
        let(:attribute_name){ :name }
      end

      it_behaves_like "a mutable attribute" do
        let(:attribute_name){ :name }
      end
    end
  end

  context "Relationships:" do
    describe "Recipes" do
      it_behaves_like "a has_many relationship" do
        let(:relation_name) { :recipes }
        let(:described) { create(:brew_method) }
      end
    end

    describe "Coffee" do
      it_behaves_like "a has_many, through relationship" do
        let(:relation_name) { :coffees }
        let(:through_name) { :recipes }
        let(:described) { create(:brew_method) }
        let(:reflexive) { nil }
      end
    end
  end
end
