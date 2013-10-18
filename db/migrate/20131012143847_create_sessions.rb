class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.references :user, index: true
      t.string :skills
      t.string :default_conditions

      t.timestamps
    end
  end
end
