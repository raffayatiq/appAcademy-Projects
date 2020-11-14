class RemoveSessionTokenColumnFromUsers < ActiveRecord::Migration[5.2]
  def up
  	remove_column :users, :session_token
  end

  def down
  	add_column :users, :session_token, :string, null: false
  	add_index :users, :session_token, unique: true
  end
end
