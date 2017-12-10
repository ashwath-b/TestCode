# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoriesHelper, type: :helper do
  let(:category) { FactoryGirl.create(:category, parent_id: nil) }
  let(:sub_category) { FactoryGirl.create(:category, name:'sub_cat', parent_id: category.id) }
  let(:sub_sub_category) { FactoryGirl.create(:category, name: 'sub_sub_cat',parent_id: sub_category.id) }

  describe 'category_list' do
    before do
      category
      sub_category
      sub_sub_category
    end
    it 'returns category list excepct for sub_sub_category' do
      result = category_list
      expect(result).to eq [[category.name, category.id], [sub_category.name, sub_category.id]]
      expect(result).not_to include [[sub_sub_category.name, sub_sub_category.id]]
    end
  end
end
