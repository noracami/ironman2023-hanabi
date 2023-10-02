class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'public_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def foobar(data)
    chat_to_public(data['body'], { nickname: data['nickname'] })
  end

  def join_game(data)
    game_room = GameRoom.find_by id: data['roomId']

    return unless game_room

    if uuid.in? game_room.game_data['players']
      broadcast("#{uuid} has already joined room #{game_room.name}")
    else
      game_room.game_data['players'] << uuid
      game_room.save

      broadcast("#{uuid} has joined room #{game_room.name}")
    end
  end

  def start_game(data)
    game_room = GameRoom.find_by id: data['roomId']

    return unless game_room

    players = game_room.game_data.dig('players') || []

    return unless players.size <= 5 && players.size >= 2

    game = game_room.game_data
    prepare_deck game
    set_info_token game
    set_fire_token game
    deliver_cards game
    set_initial_player game

    game_room.save
  end

  def play_card_randomly(data)
    game_room = GameRoom.find_by id: data['roomId']

    game = game_room.game_data

    return unless can_play?(game) && is_your_turn?(game)

    play_card = game['player_data'][uuid]['hands'].sample
    game['player_data'][uuid]['hands'] -= [play_card]
    game['discards'] ||= []
    game['discards'] << play_card
    get_fire_token game
    game['player_data'][uuid]['hands'] << game['deck'].pop
    game['current_player'] += 1
    game['current_player'] %= game['players'].size

    game['state'] = GAME_COMPLETED if game['fire_token'] >= 3

    game_room.save
  end

  GAME_INIT = 0
  GAME_PROCESSING = 1
  GAME_ENDING = 2
  GAME_COMPLETED = 3

  private

  def can_play?(game)
    game['state'] < GAME_COMPLETED
  end

  def is_your_turn?(game)
    uuid == game['players'][game['current_player']]
  end

  def set_initial_player(game)
    game['players'].shuffle!
    game['current_player'] = 0
  end

  def deliver_cards(game)
    players = game['players']
    hands_number = case players.size
                   when 2..3
                     5
                   when 4..5
                     4
                   else
                     raise "invalid players number"
                   end

    players.each do |player|
      hands = game['deck'].sample hands_number
      game['deck'] -= hands
      game['player_data'] ||= {}
      game['player_data'][player] ||= {}
      game['player_data'][player]['hands'] = hands
    end
  end

  def set_fire_token(game)
    game['fire_token'] = 0
  end

  def get_fire_token(game)
    game['fire_token'] += 1
  end

  def set_info_token(game)
    game['info_token'] = 8
  end

  def prepare_deck(game)
    game['deck'] = ('11'..'55').to_a
  end

  def broadcast(data, speaking: 'Lobby')
    ActionCable.server.broadcast 'public_channel', { message: data, role: :lobby }
  end

  def chat_to_public(data, params = {})
    nickname = params.dig(:nickname)
    ActionCable.server.broadcast 'public_channel', { message: data, role: :player, uuid:, nickname: }
  end

  def greeting(user, speaking: nil)
    case speaking
    when nil
      broadcast("welcome #{user}")
    else
      broadcast("welcome #{user}", speaking:)
    end
  end

  def goodbye(user)
    broadcast("#{user} has leaved us.")
  end
end
