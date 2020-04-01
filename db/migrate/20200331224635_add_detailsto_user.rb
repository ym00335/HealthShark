class AddDetailstoUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :height, :integer
    add_column :users, :weight, :integer
    add_column :users, :diet, :string
    add_column :users, :allergies, :text
    
  end
end
