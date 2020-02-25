class CreateMails < ActiveRecord::Migration[5.2]
  def change
    create_table :sent_mails do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :telephone, null: true
      t.string :title, null: true
      t.string :message, null: false

      t.belongs_to :user, null: true

      t.timestamps
    end
  end
end
