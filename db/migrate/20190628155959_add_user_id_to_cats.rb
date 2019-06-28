class AddUserIdToCats < ActiveRecord::Migration[5.2]
  def change
    add_column :cats, :user_id, :integer, null: false
    add_index :cats, :user_id
    add_foreign_key :cats, :users
  end
end
