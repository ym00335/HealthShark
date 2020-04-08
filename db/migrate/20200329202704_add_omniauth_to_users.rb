class AddOmniauthToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :fb_name, :string
    add_column :users, :fb_image, :text
  end
end
