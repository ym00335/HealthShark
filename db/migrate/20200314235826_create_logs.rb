class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.string :meal
      t.integer :calories
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
