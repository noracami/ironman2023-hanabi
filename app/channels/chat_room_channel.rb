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
    game_room =  GameRoom.find_by id: data['roomId']

    return unless game_room

    if uuid.in? game_room.game_data['players']
      broadcast("#{uuid} has already joined room #{game_room.name}")
    else
      game_room.game_data['players'] << uuid
      game_room.save

      broadcast("#{uuid} has joined room #{game_room.name}")
    end
  end

  private

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
