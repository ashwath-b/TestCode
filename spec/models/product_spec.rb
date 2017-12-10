# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do

  let(:category) { FactoryGirl.create(:category, name: 'cat', parent_id: nil) }
  let(:sub_category) { FactoryGirl.create(:category, name: 'sub_cat', parent_id: category.id) }
  let(:sub_sub_category) { FactoryGirl.create(:category, name:'sub_sub_cat', parent_id: sub_category.id) }
  let(:sub_sub_category_one) { FactoryGirl.create(:category, name:'sub_sub_cat_1', parent_id: sub_category.id) }

  let(:categorizations_attributes) { [ { sub_sub_category_id: sub_sub_category.id } ] }
  let(:product_one) { FactoryGirl.create(:product, categorizations_attributes: categorizations_attributes) }

  describe 'validations' do
    context 'Invalid' do
      let(:invalid_product) { FactoryGirl.build(:product, name: nil, price: nil, description: nil, categorizations_attributes: [ { sub_sub_category_id: nil } ] ) }
      it 'should contain error messages' do
        expect(invalid_product.valid?).to eq false
        expect(invalid_product.errors.messages[:name]).to include 'can\'t be blank'
        expect(invalid_product.errors.messages[:description]).to include 'can\'t be blank'
        expect(invalid_product.errors.messages[:price]).to include 'can\'t be blank'
        expect(invalid_product.errors.messages[:categorizations]).to include 'can\'t be blank'
      end

      it 'duplicate name' do
        invalid_product.name = product_one.name
        expect(invalid_product.valid?).to eq false
        expect(invalid_product.errors.messages[:name]).to include 'has already been taken'
      end
    end
    context 'valid' do
      let(:valid_product) { FactoryGirl.build(:product, name: 'name 1', price: 111, description: 'description 1', categorizations_attributes: [ { sub_sub_category_id: sub_sub_category.id } ] ) }
      it 'should be valid product' do
        expect(valid_product.valid?).to eq true
        expect(valid_product.errors.messages[:name]).to eq nil
        expect(valid_product.errors.messages[:description]).to eq nil
        expect(valid_product.errors.messages[:price]).to eq nil
        expect(valid_product.errors.messages[:categorizations]).to eq nil
      end
    end
  end

  describe 'methods' do
    before do
      category
      sub_category
      sub_sub_category
      sub_sub_category_one
    end
    context '#available_sub_sub_categories' do
      subject { Product.new.available_sub_sub_categories }
      it 'should return available sub_sub_categories' do
        expect(subject).to eq [sub_sub_category, sub_sub_category_one]
      end
    end
    context '#available_sub_categories' do
      subject { Product.new.available_sub_categories }
      it 'should return available sub_categories' do
        expect(subject).to eq [sub_category]
      end
    end
    context '#available_categories' do
      subject { Product.new.available_categories }
      it 'should return available sub_categories' do
        expect(subject).to eq [category]
      end
    end
    context '#categories_list' do
      subject { product_one.categories_list }
      it 'should list sub_sub_categories product belongs to' do
        expect(subject).to eq sub_sub_category.name
      end
    end
  end
end
