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
