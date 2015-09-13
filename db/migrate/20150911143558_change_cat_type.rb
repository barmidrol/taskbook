class ChangeCatType < ActiveRecord::Migration
  def change
    change_table :tasks do |t|
      t.change :category, :string
      t.change :difficulty, :string
    end
  end
end
