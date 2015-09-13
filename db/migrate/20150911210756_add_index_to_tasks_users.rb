class AddIndexToTasksUsers < ActiveRecord::Migration
  def change
    add_index :tasks_users, [:task_id, :user_id]
    add_index :tasks_users, :user_id
  end
end
