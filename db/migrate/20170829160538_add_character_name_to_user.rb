class AddCharacterNameToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :character_name, :string
  end
end
