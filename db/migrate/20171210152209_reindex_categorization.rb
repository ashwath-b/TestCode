class ReindexCategorization < ActiveRecord::Migration
  def up
    Categorization.reindex
  end

  def down; end
end
