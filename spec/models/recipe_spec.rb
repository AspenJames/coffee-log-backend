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

      it "throws an exception if given malformed data" do
        bad_times = ["4:75", "4.20", "3:30:25",\
          "two minutes", Time.parse("4:45"), 321, "5::30"]
        attrs = attributes_for(:recipe)
        bad_times.each do |t|
          expect{
            create(:recipe, time: t)
          }.to raise_exception(ActiveRecord::RecordInvalid)
        end
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
