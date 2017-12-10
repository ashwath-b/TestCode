# frozen_string_literal: true

require 'rails_helper'
RSpec.describe CategoriesController, type: :controller do

  let(:valid_attributes) { { name: 'name1' } }
  let(:invalid_attributes) { {name: 'name1'} }
  let(:category) { FactoryGirl.create(:category) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, {}
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, {:id => category.to_param}
      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, {}
      expect(response).to be_success
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, {:id => category.to_param}
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Category' do
        expect {
          post :create, {:category => valid_attributes}
        }.to change(Category, :count).by(1)
      end

      it 'redirects to the created category' do
        post :create, {:category => valid_attributes}
        expect(response).to redirect_to(Category.last)
      end
    end

    context 'with invalid params' do
      before { FactoryGirl.create(:category, name: 'name1') }
      it 'returns a success response (i.e. to display the \'new\' template)' do
        post :create, {:category => invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_category) {FactoryGirl.create(:category, name: 'name 3')}
      let(:new_attributes) { { name: 'new_name', parent_id: new_category.id } }

      it 'updates the requested category' do
        put :update, {:id => category.to_param, :category => new_attributes}
        category.reload
        expect(category.name).to eq 'new_name'
        expect(category.parent_id).to eq new_category.id
      end

      it 'redirects to the category' do
        put :update, {:id => category.to_param, :category => valid_attributes}
        expect(response).to redirect_to(category)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested category' do
      category = Category.create!(valid_attributes)
      expect {
        delete :destroy, {:id => category.to_param}
      }.to change(Category, :count).by(-1)
    end

    it 'redirects to the categories list' do
      delete :destroy, {:id => category.to_param}
      expect(response).to redirect_to(categories_url)
    end
  end

end
