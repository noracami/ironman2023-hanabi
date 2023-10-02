class GameRoom < ApplicationRecord

  broadcasts_to ->(game_room) { "game_rooms" }, inserts_by: :prepend
end
