class CreateDiscussions < ActiveRecord::Migration[5.2]
  def change
    create_table :discussions do |t|
      t.text :topic, null: false
      t.string :image

      t.timestamps

      t.references :owner, null: false
    end

    add_foreign_key :discussions, :user, column: :owner_id, primary_key: :id

    add_foreign_key :messages, :discussions, column: :discussion_id, primary_key: :id
  end
end
