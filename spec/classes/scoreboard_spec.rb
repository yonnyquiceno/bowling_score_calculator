# frozen_string_literal: true

require 'spec_helper'
require_relative '../../classes/scoreboard'

describe ScoreBoard do
  let(:valid_game) { File.expand_path('../support/valid-game.txt', __dir__) }
  let(:invalid_game_1) { File.expand_path('../support/invalid-game-1.txt', __dir__) }
  let(:invalid_game_2) { File.expand_path('../support/invalid-game-2.txt', __dir__) }
  let(:invalid_game_3) { File.expand_path('../support/invalid-game-3.txt', __dir__) }
  let(:invalid_game_4) { File.expand_path('../support/invalid-game-4.txt', __dir__) }
  let(:all_invalid_game) { File.expand_path('../support/all-invalid-game.txt', __dir__) }
  let(:raw_throwings) { IO.readlines(valid_game) }
  let(:player_throwings) { [3, 7, 6, 3, 10, 8, 1, 10, 10, 9, 0, 7, 3, 4, 4, 10, 9, 0] }
  let(:scoreboard) { ScoreBoard.new(valid_game) }

  describe '#game_score' do
    context 'when game is valid' do
      it 'should return a hash with the game score information' do
        expect(ScoreBoard.new(valid_game).game_score).to be_a(Hash)
        expect(ScoreBoard.new(valid_game).game_score['Jeff'][:scores])
          .to eq([20, 39, 48, 66, 74, 84, 90, 120, 148, 167])
        expect(ScoreBoard.new(valid_game).game_score['Jeff'][:pinfalls].map(&:to_s))
          .to eq(%w[\  X 7 / 9 0 \  X 0 8 8 / F 6 \  X \  X X 8 1])
      end
      it 'should print scoreboard to stdout' do
        printed = capture_stdout do
          ScoreBoard.new(valid_game).game_score
        end
        expect(printed).to include('Frame')
      end
    end
    context 'when game is not valid' do
      it 'should return an array with errors' do
        expect(ScoreBoard.new(invalid_game_1).game_score).to be_a(Array)
        expect(ScoreBoard.new(invalid_game_1).game_score)
          .to eq ['Invalid value detected: No negative values accepted for knock over pins count']
      end
      it 'should print errors to stdout' do
        printed = capture_stdout do
          ScoreBoard.new(invalid_game_1).game_score
        end
        expect(printed).to include(
          'Invalid value detected: No negative values accepted for knock over pins count'
        )
      end
      it 'should print errors to stdout' do
        printed = capture_stdout do
          ScoreBoard.new(invalid_game_3).game_score
        end
        expect(printed).to include(
          'Invalid score e: Only Integer numbers or literal \'F\' (indicating a foul) are allowed values (case sensitive)'
        )
      end
      it 'should print errors to stdout' do
        printed = capture_stdout do
          ScoreBoard.new(invalid_game_2).game_score
        end
        expect(printed).to include(
          'Invalid value detected: Knock over pins count per frame should not be major than 10'
        )
      end
      it 'should print errors to stdout' do
        printed = capture_stdout do
          ScoreBoard.new(invalid_game_4).game_score
        end
        expect(printed).to include(
          'Invalid game: Player John has not completed all game frames'
        )
      end
      it 'should print errors to stdout' do
        printed = capture_stdout do
          ScoreBoard.new(all_invalid_game).game_score
        end
        expect(printed).to include(
          'Invalid score Y: Only Integer numbers or literal \'F\' (indicating a foul) are allowed values (case sensitive)'
        )
        expect(printed).to include(
          'Invalid game: Player Frank has not completed all game frames'
        )
        expect(printed).to include(
          'Invalid value detected: Knock over pins count per frame should not be major than 10'
        )
        expect(printed).to include(
          'Invalid value detected: No negative values accepted for knock over pins count'
        )
      end
    end
  end

  describe '#calculate_results' do
    it 'returns a hash with player names as keys and player pinfalls and scores as values' do
      separated_throwings = scoreboard.send(:throwings_by_player)
      game_results = scoreboard.send(:calculate_results, separated_throwings)
      expect(game_results.keys).to match_array(%w[John Jeff])
      expect(game_results['John'][:pinfalls].map(&:to_s)).to eq(%w[3 / 6 3 \  X 8 1 \  X \  X 9 0 7 / 4 4 X 9 0])
      expect(game_results['John'][:scores]).to eq([16, 25, 44, 53, 82, 101, 110, 124, 132, 151])
      expect(game_results['Jeff'][:pinfalls].map(&:to_s)).to eq(%w[\  X 7 / 9 0 \  X 0 8 8 / F 6 \  X \  X X 8 1])
      expect(game_results['Jeff'][:scores]).to eq([20, 39, 48, 66, 74, 84, 90, 120, 148, 167])
    end
  end

  describe '#throwings_by_player' do
    it 'separates each player throwings' do
      separated_throwings = scoreboard.send(:throwings_by_player)
      expect(separated_throwings.keys).to match_array(%w[John Jeff])
      expect(separated_throwings['John']).to match_array(%w[3 7 6 3 10 8 1 10 10 9 0 7 3 4 4 10 9 0])
      expect(separated_throwings['Jeff']).to match_array(%w[10 7 3 9 0 10 0 8 8 2 F 6 10 10 10 8 1])
    end
  end

  describe '#player_scoreboard' do
    it 'returns an array with overall player\'s pinfalls on first position and scores on second' do
      pinfalls, scores = scoreboard.send(:player_scoreboard, player_throwings)
      expect(pinfalls.map(&:to_s)).to eq(%w[3 / 6 3 \  X 8 1 \  X \  X 9 0 7 / 4 4 X 9 0])
      expect(scores).to eq [16, 25, 44, 53, 82, 101, 110, 124, 132, 151]
    end
  end
end
