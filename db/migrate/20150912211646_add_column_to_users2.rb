class AddColumnToUsers2 < ActiveRecord::Migration
  def change
    add_column :users, :solved, :integer
  end
end
