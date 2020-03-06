require 'rails_helper'

RSpec.describe Recipe, type: :model do
  context "Attributes:" do
    describe "dose" do
      it_behaves_like "an optional attribute" do
        let(:attribute_name){ :dose }
      end

      it_behaves_like "a mutable attribute" do
        let(:attribute_name){ :dose }
        let(:update_value){ 18 }
      end
    end

    describe "output" do
      it_behaves_like "an optional attribute" do
        let(:attribute_name){ :output }
      end

      it_behaves_like "a mutable attribute" do
        let(:attribute_name){ :output }
        let(:update_value){ 600 }
      end
    end

    describe "time" do
      it_behaves_like "an optional attribute" do
        let(:attribute_name){ :time }
      end

      it_behaves_like "a mutable attribute" do
        let(:attribute_name){ :time }
        let(:update_value){ "5:30" }
      end
    end
  end

  context "Relationships:" do
    describe "BrewMethod" do
      it_behaves_like "a belongs_to relationship" do
        let(:relation_name) { :brew_method }
        let(:described) { create(:recipe) }
      end
    end

    describe "Coffee" do
      it_behaves_like "a belongs_to relationship" do
        let(:relation_name) { :coffee }
        let(:described) { create(:recipe) }
      end
    end

    describe "Entry" do
      it_behaves_like "a belongs_to relationship" do
        let(:relation_name) { :entry }
        let(:described) { create(:recipe) }
        let(:reflexive) { :recipe }
      end
    end
  end
end
