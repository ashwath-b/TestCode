# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoriesController, type: :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(:get => '/admin/categories').to route_to('categories#index')
    end

    it 'routes to #new' do
      expect(:get => '/admin/categories/new').to route_to('categories#new')
      expect(:get => '/categories/new').not_to route_to('categories#new')
    end

    it 'routes to #show' do
      expect(:get => '/admin/categories/1').to route_to('categories#show', :id => '1')
    end

    it 'routes to #edit' do
      expect(:get => '/admin/categories/1/edit').to route_to('categories#edit', :id => '1')
      expect(:get => '/categories/1/edit').not_to route_to('categories#edit', :id => '1')
    end

    it 'routes to #create' do
      expect(:post => '/admin/categories').to route_to('categories#create')
      expect(:post => '/categories').not_to route_to('categories#create')
    end

    it 'routes to #update via PUT' do
      expect(:put => '/admin/categories/1').to route_to('categories#update', :id => '1')
      expect(:put => '/categories/1').not_to route_to('categories#update', :id => '1')
    end

    it 'routes to #update via PATCH' do
      expect(:patch => '/admin/categories/1').to route_to('categories#update', :id => '1')
      expect(:patch => '/categories/1').not_to route_to('categories#update', :id => '1')
    end

    it 'routes to #destroy' do
      expect(:delete => '/admin/categories/1').to route_to('categories#destroy', :id => '1')
      expect(:delete => '/categories/1').not_to route_to('categories#destroy', :id => '1')
    end
  end
end
