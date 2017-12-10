# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsController, type: :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(:get => '/admin/products').to route_to('products#index')
    end

    it 'routes to #new' do
      expect(:get => '/admin/products/new').to route_to('products#new')
      expect(:get => '/products/new').not_to route_to('products#new')
    end

    it 'routes to #show' do
      expect(:get => '/admin/products/1').to route_to('products#show', :id => '1')
    end

    it 'routes to #edit' do
      expect(:get => '/admin/products/1/edit').to route_to('products#edit', :id => '1')
      expect(:get => '/products/1/edit').not_to route_to('products#edit', :id => '1')
    end

    it 'routes to #create' do
      expect(:post => '/admin/products').to route_to('products#create')
      expect(:post => '/products').not_to route_to('products#create')
    end

    it 'routes to #update via PUT' do
      expect(:put => '/admin/products/1').to route_to('products#update', :id => '1')
      expect(:put => '/products/1').not_to route_to('products#update', :id => '1')
    end

    it 'routes to #update via PATCH' do
      expect(:patch => '/admin/products/1').to route_to('products#update', :id => '1')
      expect(:patch => '/products/1').not_to route_to('products#update', :id => '1')
    end

    it 'routes to #destroy' do
      expect(:delete => '/admin/products/1').to route_to('products#destroy', :id => '1')
      expect(:delete => '/products/1').not_to route_to('products#destroy', :id => '1')
    end

    it 'routes to #public_view' do
      expect(:get => '/').to route_to('products#public_view')
    end

    it 'routes to #public_view' do
      expect(:get => '/1').to route_to('products#public_view', category_id: '1')
    end

    it 'routes to #public_view' do
      expect(:get => '/1/3').to route_to('products#public_view', category_id: '1', sub_category_id: '3')
    end

    it 'routes to #public_view' do
      expect(:get => '/1/3/5').to route_to('products#public_view', category_id: '1', sub_category_id: '3', sub_sub_category_id: '5')
    end

  end
end
