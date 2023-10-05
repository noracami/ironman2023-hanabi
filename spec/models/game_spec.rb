require 'rails_helper'

RSpec.describe Game, type: :model do
  context "#new" do
    let(:host) { SecureRandom.urlsafe_base64 }
    let(:game_room) { GameRoom.create(name: "new game", game_data: {mode: 0, players: [host]}) }
    let(:game) { Game.new(game_room) }

    it "要有名稱" do
      expect(game.name).to be_truthy
    end

    it "要有模式" do
      expect(game.mode).to be_truthy
    end

    it "狀態是 `STATE[GAME_INIT]`" do
      expect(game.state).to eq Game::STATE[:GAME_INIT]
    end

    it "參與的玩家 >= 1" do
      expect(game.players.size).to be >= 1
    end

    it "要有資料庫的ＩＤ" do
      expect(game.id).to be_truthy
    end
  end
end
