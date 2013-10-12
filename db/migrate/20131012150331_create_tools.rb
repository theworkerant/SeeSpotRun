class CreateTools < ActiveRecord::Migration
  def change
    create_table :tools do |t|
      t.string :name
      t.integer :point_basis

      t.timestamps
    end
  end
end
