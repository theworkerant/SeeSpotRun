class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name
      t.string :category
      t.integer :point_basis

      t.timestamps
    end
  end
end
