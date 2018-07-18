# frozen_string_literal: true

# This main Class calculates and prints players scoreboard using input text file
class ScoreBoard
  include Printable
  include Validatable

  def initialize(filename)
    @raw_throwings = FileReader.new(filename).read_file
    @frame_recorder = FrameRecorder.new
  end

  def game_score
    validate_game(throwings_by_player)
    game_scoreboard = calculate_results(throwings_by_player)
    print_results(game_scoreboard)
  rescue RuntimeError
    print_errors
  end

  private

  def throwings_by_player
    @throwings_by_player ||= @raw_throwings.each_with_object({}) do |score_line, separated_throwings|
      next if score_line.strip == '' # prevent errors caused by empty lines
      player_name, throw_score = score_line.strip.split(' ') # turns 'Jeff 10' into ['Jeff', '10']
      separated_throwings[player_name] ||= []
      separated_throwings[player_name] << throw_score
    end
  end

  def calculate_results(separated_throwings)
    separated_throwings.each_with_object({}) do |throwings_info, game_results|
      player_name, player_throwings = throwings_info
      pinfalls, scores = player_scoreboard(player_throwings)
      game_results[player_name] = { pinfalls: pinfalls, scores: scores }
    end
  end

  def player_scoreboard(player_throwings)
    @frame_recorder.reset
    player_throwings.each_with_index do |throwing, i|
      break if @frame_recorder.frame_count == 10
      if @frame_recorder.skip_next
        @frame_recorder.skip_next = false
        next
      end
      next_throwing, after_next_throwing = player_throwings[(i + 1)..(i + 2)].map(&:to_i)
      @frame_recorder.record(throwing, next_throwing, after_next_throwing)
    end
    validate_frame_count(@frame_recorder.frame_count) # check if user have completed all 10 game frames
    [@frame_recorder.pinfalls_keeper, @frame_recorder.score_keeper]
  end
end
