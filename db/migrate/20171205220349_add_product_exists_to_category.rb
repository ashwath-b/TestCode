class AddProductExistsToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :product_exists, :boolean, default: false
  end
end
