class CreateCommands < ActiveRecord::Migration[8.0]
  def change
    create_table :commands do |t|
      t.string :action, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
