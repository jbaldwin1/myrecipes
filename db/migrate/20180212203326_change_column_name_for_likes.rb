class ChangeColumnNameForLikes < ActiveRecord::Migration[5.0]
  def change
    rename_column :likes, :likes, :like
  end
end
