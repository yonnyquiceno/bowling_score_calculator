require 'spec_helper'
require_relative '../../classes/scoreboard'

describe ScoreBoard do
  let(:valid_game) { File.expand_path('../support/valid-game.txt', __dir__) }
  let(:invalid_game_1) { File.expand_path('../support/invalid-game-1.txt', __dir__) }
  let(:invalid_game_2) { File.expand_path('../support/invalid-game-2.txt', __dir__) }
  let(:invalid_game_3) { File.expand_path('../support/invalid-game-3.txt', __dir__) }
  let(:invalid_game_4) { File.expand_path('../support/invalid-game-4.txt', __dir__) }
  let(:all_invalid_game) { File.expand_path('../support/all-invalid-game.txt', __dir__) }

  describe '#game_score' do
    context 'when game is valid' do
      it 'should return true' do
        expect(ScoreBoard.game_score(valid_game)).to be true
      end
      it 'should print scoreboard to stdout' do
        printed = capture_stdout do
          ScoreBoard.game_score(valid_game)
        end
        expect(printed).to include('Frame')
      end
    end
    context 'when game is not valid' do
      it 'should return false' do
        expect(ScoreBoard.game_score(invalid_game_1)).to be false
      end
      it 'should print errors to stdout' do
        printed = capture_stdout do
          ScoreBoard.game_score(invalid_game_1)
        end
        expect(printed).to include(
          'Invalid value detected: No negative values accepted for knock over pins count'
        )
      end
      it 'should print errors to stdout' do
        printed = capture_stdout do
          ScoreBoard.game_score(invalid_game_3)
        end
        expect(printed).to include(
          'Invalid character e: The only non-numeric allowed value is F (case-sensitive)'
        )
      end
      it 'should print errors to stdout' do
        printed = capture_stdout do
          ScoreBoard.game_score(invalid_game_2)
        end
        expect(printed).to include(
          'Invalid value detected: Knock over pins count per frame should not be major than 10'
        )
      end
      it 'should print errors to stdout' do
        printed = capture_stdout do
          ScoreBoard.game_score(invalid_game_4)
        end
        expect(printed).to include(
          'Invalid game: Player John has not completed all game frames'
        )
      end
      it 'should print errors to stdout' do
        printed = capture_stdout do
          ScoreBoard.game_score(all_invalid_game)
        end
        expect(printed).to include(
          'Invalid character Y: The only non-numeric allowed value is F (case-sensitive)'
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
end
