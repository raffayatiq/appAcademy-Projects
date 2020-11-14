class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions do |t|
    	t.integer :user_id, null: false
    	t.string :session_token, null: false
    end

    add_index :sessions, :session_token, unique: true
  end
end
