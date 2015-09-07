class AddColumnsToAuthentication < ActiveRecord::Migration
  def change
    add_column :authentications, :username, :string
  end
end
