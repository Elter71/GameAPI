class CreateCharacters < ActiveRecord::Migration[5.1]
  def change
    create_table :characters, id: false do |t|
      t.text :name, primary_key: true
      t.timestamps
    end
  end
end
