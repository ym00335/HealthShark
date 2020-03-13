class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.string :meal
      t.integer :calories
      t.integer :meal_rating

      t.timestamps
    end
  end
end
