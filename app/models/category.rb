# frozen_string_literal: true

class Category < ActiveRecord::Base
  has_many :categorizations
  has_many :products, through: :categorizations

  has_many :sub_categories, class_name: 'Category', foreign_key: 'parent_id'
  belongs_to :parent_category, class_name: 'Category', foreign_key: 'parent_id'

  validates :name, uniqueness: true, presence: true, case_sensitive: false

  def self.category_list
    category = where(parent_id: nil)
    sub_category = category.map{|c| c.sub_categories}
    (category + sub_category).flatten.uniq
  end

  def self.set_product_exists(cat_id, sub_cat_id, sub_sub_cat_id)
    cat = Category.where(id: [cat_id, sub_cat_id, sub_sub_cat_id]).update_all(product_exists: true)
  end

  def self.available_filters
    where(product_exists: true)
  end

  def product_count
    case category_type
      when 'category' then categorizations.count
      when 'sub_category' then Categorization.where(sub_category_id: id).count
      when 'sub_sub_category' then Categorization.where(sub_sub_category_id: id).count
      else 0
    end
  end

  def category_type
    return 'sub_sub_category' if parent_category&.parent_category.present?
    return 'sub_category' if parent_category.present?
    return 'category'
  end
end
