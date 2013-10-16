class SkillConditions < ActiveRecord::Migration
  def change
    create_table :skill_conditions do |t|
      t.references :skill, index: true
      t.references :condition, index: true

      t.timestamps
    end
  end
end
