class CreateConditions < ActiveRecord::Migration
  def change
    create_table :conditions do |t|
      t.string :name
      t.string :category
      t.integer :point_basis

      t.timestamps
    end
  end
end
