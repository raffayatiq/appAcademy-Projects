class AddPremiumUserColumnToUsers < ActiveRecord::Migration[5.2]
  def up
  	change_table :users do |t|
  		t.boolean :premium, default: false, presence: true
  	end
  	User.all.each do |user|
  		user.premium = false
  		user.save!
  	end
  end

  def down
  	remove_column :users, :premium
  end
end
