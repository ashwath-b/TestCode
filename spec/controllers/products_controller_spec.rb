# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsController, type: :controller do

  let(:category) { FactoryGirl.create(:category) }
  let(:sub_category) { FactoryGirl.create(:category, name: 'sub_cat_1', parent_id: category.id) }
  let(:sub_sub_category) { FactoryGirl.create(:category, name:'sub_sub_cat', parent_id: sub_category.id) }
  let(:sub_sub_category_one) { FactoryGirl.create(:category, name:'sub_sub_cat_1', parent_id: sub_category.id) }
  let(:valid_attributes) { { name: 'product 1', price: 11.1, description: 'product 1 description', categorizations_attributes: [{sub_sub_category_id: sub_sub_category.id}] } }
  let(:invalid_name_attributes) { { price: 11.1, description: 'product 1 description' } }
  let(:invalid_description_attributes) { { name: 'product_1', price: 11.1 } }
  let(:invalid_price_1_attributes) { { name: 'product_1', price: 11.1 } }
  let(:product) { FactoryGirl.create(:product, valid_attributes) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, {}
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, {:id => product.to_param}
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
      get :edit, {:id => product.to_param}
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Product' do
        expect {
          post :create, {:product => valid_attributes}
        }.to change(Product, :count).by(1)
      end

      it 'creates a new Categorization' do
        expect {
          post :create, {:product => valid_attributes}
        }.to change(Categorization, :count).by(1)
      end

      it 'redirects to the created product' do
        post :create, {:product => valid_attributes}
        expect(response).to redirect_to(Product.last)
      end
    end

    context 'with invalid params' do
      before { FactoryGirl.create(:product, name: 'product 1', categorizations_attributes: [{sub_sub_category_id: sub_sub_category.id}]) }
      it 'returns a success response (i.e. to display the \'new\' template)' do
        post :create, {:product => invalid_name_attributes}
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:categorizations_attributes) { [ { sub_sub_category_id: sub_sub_category_one.id , id: product.categorizations[0].id } ] }
      let(:new_attributes) { { name: 'new_name', description: 'new description', categorizations_attributes: categorizations_attributes } }

      it 'updates the requested product' do
        put :update, {:id => product.to_param, :product => new_attributes}
        product.reload
        expect(product.name).to eq 'new_name'
        expect(product.description).to eq 'new description'
      end

      it 'redirects to the product' do
        put :update, {:id => product.to_param, :product => new_attributes}
        expect(response).to redirect_to(product)
      end

      it 'update product_exists' do
        product
        sub_sub_category.reload
        expect(sub_sub_category.product_exists).to eq true
        expect(sub_sub_category_one.product_exists).to eq false
        put :update, {:id => product.to_param, :product => new_attributes}
        sub_sub_category.reload
        sub_sub_category_one.reload
        expect(sub_sub_category.product_exists).to eq false
        expect(sub_sub_category_one.product_exists).to eq true
      end

      it 'should not create a categorizations' do
        expect {
          put :update, {:id => product.to_param, :product => new_attributes}
        }.not_to change(product.categorizations, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested product' do
      product = Product.create! valid_attributes
      expect {
        delete :destroy, {:id => product.to_param}
      }.to change(Product, :count).by(-1)
    end

    it 'redirects to the products list' do
      delete :destroy, {:id => product.to_param}
      expect(response).to redirect_to(products_url)
    end

    it 'destroys the categorization record' do
      c_count = product.categorizations.count
      expect {
        delete :destroy, { id: product.to_param }
      }.to change(Categorization, :count).by(-c_count)
    end
  end

end
