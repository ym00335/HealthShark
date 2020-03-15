class RemoveUnecessaryModels < ActiveRecord::Migration[5.2]
  def up
    drop_table :logs
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
