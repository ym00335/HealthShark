class AddNameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :username, :string
    add_column :users, :encrypted_date_of_birth, :datetime
    add_column :users, :encrypted_date_of_birth_iv, :datetime
    add_column :users, :encrypted_is_female, :boolean
    add_column :users, :encrypted_is_female_iv, :boolean
    add_column :users, :is_signed_in, :boolean, default: true
  end
end
