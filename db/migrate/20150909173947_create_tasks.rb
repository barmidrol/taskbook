class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
    	t.string :title
    	t.text :content
    	t.integer :category
    	t.integer :difficulty
    	t.text :answers, array: true
      t.timestamps null: false
    end
  end
end
