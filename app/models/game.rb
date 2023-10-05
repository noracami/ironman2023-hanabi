class Game
  STATE = {
    GAME_INIT: 0,
    GAME_PROCESSING: 1,
    GAME_ENDING: 2,
    GAME_COMPLETED: 3
  }

  MODE = {
    "基本 5 色": 0,
    "6 色 10 張": 1,
    "6 色 5 張": 2,
    "彩色": 3,
  }

  attr_accessor :id, :name, :mode, :players, :state, :game_room_id, :game_room

  def initialize(game_room)
    @game_room = game_room
    params = game_room.game_data || {}

    @id = game_room.id
    @name = game_room.name
    @mode = params.dig "mode"
    @players = params.dig "players"
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
