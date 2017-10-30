class CreateArenas < ActiveRecord::Migration[5.1]
  def change
    create_table :arenas do |t|
      t.text :character_1_name
      t.text :character_2_name
      t.text :status
      t.text :winner_name
      t.timestamps
    end
  end
end
