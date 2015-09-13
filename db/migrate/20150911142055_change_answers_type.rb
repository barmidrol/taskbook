class ChangeAnswersType < ActiveRecord::Migration
  def change
    change_table :tasks do |t|
      t.change :answers, :string
    end
  end
end
