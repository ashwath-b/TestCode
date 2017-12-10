# frozen_string_literal: true

class Categorization < ActiveRecord::Base
  belongs_to :category
  belongs_to :sub_category, class_name: 'Category', foreign_key: 'sub_category_id'
  belongs_to :sub_sub_category, class_name: 'Category', foreign_key: 'sub_sub_category_id'

  belongs_to :product

  validates :product_id, uniqueness: { scope: [:category_id, :sub_category_id, :sub_sub_category_id] }
  validates_presence_of :category_id, :sub_category_id, :sub_sub_category_id
  validates_associated :category, :sub_category, :sub_sub_category, :product

  before_validation :set_other_fields, on: :create
  after_save :update_product_exists, if: proc { sub_sub_category_id_changed? && !sub_sub_category_id_was.nil? }
  before_destroy :update_category_if_last

  private
  def set_other_fields
    cat = Category.find(sub_sub_category_id)
    self.sub_category_id = cat.parent_category.id
    self.category_id = cat.parent_category.parent_category.id
    Category.set_product_exists(category_id, sub_category_id, sub_sub_category_id)
  end

  def update_product_exists
    update_sub_sub_category(sub_sub_category_id_was)
    update_sub_sub_category(sub_sub_category_id)
    update_sub_category(sub_category_id)
    update_category(category_id)
  end

  ['sub_sub_category', 'sub_category', 'category'].each do |cat|
    define_method("update_#{cat}") do |cat_id|
      bool_value = Categorization.where(:"#{cat}_id".to_sym => cat_id).count > 0
      update_category_product_exist(cat_id, bool_value)
    end
  end

  def update_category_product_exist(id, value)
    Category.find(id).update_attributes(product_exists: value)
  end

  def update_category_if_last
    bool_value = Categorization.where(sub_sub_category_id: sub_sub_category_id).count > 1
    update_category_product_exist(sub_sub_category_id, bool_value)
  end
end
