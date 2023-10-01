json.extract! game_room, :id, :name, :game_data, :created_at, :updated_at
json.url game_room_url(game_room, format: :json)
