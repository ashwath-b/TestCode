# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { FactoryGirl.create(:category, name: 'cat', parent_id: nil) }
  let(:sub_category) { FactoryGirl.create(:category, name: 'sub_cat', parent_id: category.id) }
  let(:sub_sub_category) { FactoryGirl.create(:category, name:'sub_sub_cat', parent_id: sub_category.id) }
  let(:sub_sub_category_one) { FactoryGirl.create(:category, name:'sub_sub_cat_1', parent_id: sub_category.id) }

  describe 'validations' do
    context 'invalid' do
      let(:invalid_category) { FactoryGirl.build(:category, name: nil) }
      it 'should be invalid, with respective error messages' do
        expect(invalid_category.valid?).to eq false
        expect(invalid_category.errors.messages[:name]).to include 'can\'t be blank'
      end

      it 'duplicate name' do
        invalid_category.name = category.name
        expect(invalid_category.valid?).to eq false
        expect(invalid_category.errors.messages[:name]).to include 'has already been taken'
      end
    end

    context 'valid' do
      let(:valid_category) { FactoryGirl.build(:category, name: 'new category') }
      it 'should be valid category' do
        expect(valid_category.valid?).to eq true
        expect(valid_category.errors.messages.empty?).to eq true
      end
    end
  end

  describe 'methods' do
    context '#category_list' do
      before do
        category
        sub_category
        sub_sub_category
      end
      subject { Category.category_list }
      it 'returns category and sub_category list' do
        expect(subject).to eq [category, sub_category]
        expect(subject).not_to include sub_sub_category
      end
    end
  end
end
