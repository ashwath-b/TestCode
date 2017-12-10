# frozen_string_literal: true

class Product < ActiveRecord::Base
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations
  has_many :sub_categories, through: :categorizations
  has_many :sub_sub_categories, through: :categorizations

  accepts_nested_attributes_for :categorizations, reject_if: proc { |attributes| attributes['sub_sub_category_id'].blank? }, allow_destroy: true

  validates :name, :price, :description, presence: true
	validates :name, uniqueness: true
  validates :price, numericality: { greater_than: 0 }

  validates_presence_of :categorizations

  def available_sub_sub_categories
    available_sub_categories.map{ |c| c.sub_categories }.flatten
  end

  def available_sub_categories
    available_categories.map{|c| c.sub_categories}.flatten
  end

  def available_categories
    Category.where(parent_id: nil)
  end

  def categories_list
    categorizations.map{|c| c.sub_sub_category.name}.flatten.join(', ')
  end

end
