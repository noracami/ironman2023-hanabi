class Game
  STATE = {
    GAME_INIT: 0,
    GAME_PROCESSING: 1,
    GAME_ENDING: 2,
    GAME_COMPLETED: 3
  }

  attr_accessor :name, :state, :game_room_id, :game_room

  def initialize(game_room)
    @game_room = game_room
    params = game_room.game_data || {}

    @name = params.dig :name
    @players = []
    @current_player = nil
    @deck = []
    @discards = []
    @state = STATE[:GAME_INIT]
    @fire_token = nil
    @info_token = nil
  end

  def save
    game_room.game_data ||= {}
    game_room.game_data['state'] = state
    game_room.save
  end
end
