class CreateSessionSkills < ActiveRecord::Migration
  def change
    create_table :session_skills do |t|
      t.references :session, index: true
      t.references :skill, index: true

      t.timestamps
    end
  end
end
