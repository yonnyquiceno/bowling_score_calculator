# This main Class calculates and prints players scoreboard using input text file
class ScoreBoard
  extend Calculable
  extend Printable
  extend Validatable

  def self.game_score(filename)
    raw_throwings = IO.readlines(filename)
    throwings_by_player = throwings_by_player(raw_throwings)
    validate_game(throwings_by_player)
    print_results(scoreboards(throwings_by_player))
    true
  rescue RuntimeError
    print_errors
    false
  end
end