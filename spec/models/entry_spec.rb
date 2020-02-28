require 'rails_helper'

RSpec.describe Entry, type: :model do
  context "Attributes:" do
    describe "date" do
      it_behaves_like "a required attribute" do
        let(:attribute_name) { :date }
      end

      it_behaves_like "an immutable attribute" do
        let(:attribute_name) { :date }
      end
    end

    describe "prep_notes" do
      it_behaves_like "an optional attribute" do
        let(:attribute_name) { :prep_notes }
      end

      it_behaves_like "a mutable attribute" do
        let(:attribute_name) { :prep_notes }
      end
    end

    describe "description" do
      it_behaves_like "a required attribute" do
        let(:attribute_name) { :description }
      end

      it_behaves_like "a mutable attribute" do
        let(:attribute_name) { :description }
      end
    end

    describe "rating" do
      it_behaves_like "a required attribute" do
        let(:attribute_name) { :rating }
      end

      it_behaves_like "a mutable attribute" do
        let(:attribute_name) { :rating }
        let(:update_value) { 2 }
      end
    end
  end

  context "Relationships:" do
    describe "Recipe" do
      it_behaves_like "a has_one relationship" do
        let(:described) { create(:entry) }
        let(:relation_name) { :recipe }
      end
    end

    describe "Coffee" do
    end
  end
end
