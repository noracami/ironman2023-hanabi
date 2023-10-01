class CreateGameRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :game_rooms do |t|
      t.string :name
      t.json :game_data

      t.timestamps
    end
  end
end
