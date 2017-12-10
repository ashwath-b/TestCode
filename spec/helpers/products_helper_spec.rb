# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsHelper, type: :helper do
  let(:category) { FactoryGirl.create(:category, parent_id: nil) }
  let(:sub_category) { FactoryGirl.create(:category, name:'sub_cat', parent_id: category.id) }
  let(:sub_sub_category) { FactoryGirl.create(:category, name: 'sub_sub_cat',parent_id: sub_category.id) }

  describe 'available_sub_sub_categories' do
    before do
      category
      sub_category
      sub_sub_category
    end
    it 'returns available_sub_sub_categories' do
      result = Product.new.available_sub_sub_categories
      expect(result).to eq [sub_sub_category]
      expect(result).not_to include category
      expect(result).not_to include sub_category
    end
  end
end
