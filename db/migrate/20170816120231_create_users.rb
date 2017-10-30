class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users,id: false do |t|
      t.integer :number
      t.text :password

      t.timestamps
    end
  end
end
