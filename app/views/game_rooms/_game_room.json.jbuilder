json.extract! game_room, :id, :name, :created_at, :updated_at
json.url game_room_url(game_room, format: :json)
