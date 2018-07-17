require 'spec_helper'

describe Calculable do
  let(:dummy_class) do
    Class.new do
      extend Calculable
      extend Validatable
    end
  end
  let(:valid_game) { File.expand_path('../support/valid-game.txt', __dir__) }
  let(:raw_throwings) { IO.readlines(valid_game) }
  let(:player_throwings) { [3, 7, 6, 3, 10, 8, 1, 10, 10, 9, 0, 7, 3, 4, 4, 10, 9, 0] }
  describe '#throwings_by_player' do
    it 'separates each player throwings' do
      separated_throwings = dummy_class.throwings_by_player(raw_throwings)
      expect(separated_throwings.keys).to match_array(%w(John Jeff))
      expect(separated_throwings['John']).to match_array(%w(3 7 6 3 10 8 1 10 10 9 0 7 3 4 4 10 9 0))
      expect(separated_throwings['Jeff']).to match_array(%w(10 7 3 9 0 10 0 8 8 2 F 6 10 10 10 8 1))
    end
  end
  describe '#player_scoreboard' do
    it 'returns an array with overall player\'s pinfalls on first position and scores on second' do
      pinfalls, scores = dummy_class.player_scoreboard(player_throwings)
      expect(pinfalls.map(&:to_s)).to eq %w(3 / 6 3 \  X 8 1 \  X \  X 9 0 7 / 4 4 X 9 0)
      expect(scores).to eq [16, 25, 44, 53, 82, 101, 110, 124, 132, 151]
    end
  end
end