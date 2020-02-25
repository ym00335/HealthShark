class ChangeIsFemale < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :is_female
    add_column :users, :is_female, :boolean
  end
end
