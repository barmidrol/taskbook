class ChangeUsersSolvedDefault < ActiveRecord::Migration
  def change
    change_column_default :users, :solved, 0
  end
end
