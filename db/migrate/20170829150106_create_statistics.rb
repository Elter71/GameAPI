class CreateStatistics < ActiveRecord::Migration[5.1]
  def change
    create_table :statistics, id: false do |t|
      t.text :character_name, primary_key: true
      t.integer :stamina
      t.integer :strength
      t.integer :dexterity
      t.integer :experience
      t.integer :level

      t.timestamps
    end
  end
end
