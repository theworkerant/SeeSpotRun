class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.references :user, index: true
      t.references :routine, index: true
      t.boolean :is_template

      t.timestamps
    end
  end
end
