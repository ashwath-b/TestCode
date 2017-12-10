# frozen_string_literal: true

module ProductsHelper
  def sub_sub_category_list(product)
    list = product.available_sub_sub_categories
    list.map{|c| [c.name, c.id]}
  end
end
