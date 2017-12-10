# frozen_string_literal: true

module CategoriesHelper
  def category_list
    Category.category_list.map{|c| [c.name, c.id]}
  end
end
