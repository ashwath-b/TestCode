# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Categorization, type: :model do
  let(:category) { FactoryGirl.create(:category, name: 'cat', parent_id: nil) }
  let(:sub_category) { FactoryGirl.create(:category, name: 'sub_cat', parent_id: category.id) }
  let(:sub_sub_category) { FactoryGirl.create(:category, name:'sub_sub_cat', parent_id: sub_category.id) }
  let(:sub_sub_category_one) { FactoryGirl.create(:category, name:'sub_sub_cat_1', parent_id: sub_category.id) }

  let(:categorizations_attributes) { [ { sub_sub_category_id: sub_sub_category.id } ] }
  let(:product) { FactoryGirl.create(:product, categorizations_attributes: categorizations_attributes) }

  describe 'validations' do
    context 'invalid' do
      let(:invalid_categorization) { FactoryGirl.build(:categorization, category_id: nil, sub_category_id: nil, sub_sub_category_id: nil, product_id: nil) }
      # before { allow(Category).to receive(:find).with(nil).and_return(nil) }
      it 'should contain error messages' do
        expect {
          invalid_categorization.valid?
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
      it 'duplicate row' do
        invalid_categorization.category_id = category.id
        invalid_categorization.sub_category_id = sub_category.id
        invalid_categorization.sub_sub_category_id = sub_sub_category.id
        invalid_categorization.product_id = product.id
        expect(invalid_categorization.valid?).to eq false
        expect(invalid_categorization.errors.messages[:product_id]).to include 'has already been taken'
      end
    end

    context 'valid' do
      let(:valid_categorization) { FactoryGirl.build(:categorization, category_id: category.id, sub_category_id: sub_category.id, sub_sub_category_id: sub_sub_category_one.id, product_id: product.id) }
      it 'shoyld be valid categorization' do
        expect(valid_categorization.valid?).to eq true
        expect(valid_categorization.category.product_exists).to eq true
        expect(valid_categorization.sub_category.product_exists).to eq true
        expect(valid_categorization.sub_sub_category.product_exists).to eq true
      end
    end
  end
end
