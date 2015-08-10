class RemovePasswordDigest < ActiveRecord::Migration
  def up
  	unless column_exists? :users, :remember_token
  		remove_column :users, :remember_token
  		remove_index  :users , :remember_token
  	end
  	remove_column :users ,:password_digest 
  end

  def down
  end
end
