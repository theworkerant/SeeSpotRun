class CreateSessionTools < ActiveRecord::Migration
  def change
    create_table :session_tools do |t|
      t.references :session, index: true
      t.references :tool, index: true

      t.timestamps
    end
  end
end
