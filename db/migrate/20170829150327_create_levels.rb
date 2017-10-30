class CreateLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :levels, id: false do |t|
      t.integer :level, primary_key: true
      t.integer :experience_to_next
      t.timestamps
    end
  end
end
