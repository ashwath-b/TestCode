class CreateCategorizations < ActiveRecord::Migration
  def change
    create_table :categorizations do |t|
      t.integer :product_id
      t.integer :category_id
      t.integer :sub_category_id
      t.integer :sub_sub_category_id

      t.timestamps null: false
    end
  end
end
