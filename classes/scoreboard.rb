# This main Class calculates and prints players scoreboard using input text file
class ScoreBoard
  include Printable
  include Validatable
  include Checkable

  def initialize(filename)
    @raw_throwings = read_file(filename)
  end

  def game_score
    validate_game(throwings_by_player)
    game_results = calculate_results(throwings_by_player)
    print_results(game_results)
  rescue RuntimeError
    print_errors
  end

  private

  def throwings_by_player
    @throwings_by_player ||= @raw_throwings.each_with_object({}) do |score_line, separated_throwings|
                              next if score_line.strip == '' # prevent errors by empty lines
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
    reset_scoreboard
    player_throwings.each_with_index do |throwing, i|
      if @skip_next then @skip_next = false; next end
      @next_throwing, @after_next_throwing = player_throwings[(i + 1)..(i + 2)].map(&:to_i)
      record_frame(throwing)
      @frame = @score_keeper.size
      break if @frame == 10
    end
    validate_frame_count(@frame)
    [@pinfalls_keeper, @score_keeper]
  end

  def record_frame(throwing)
    add_strike if strike?(throwing)
    add_spare(throwing) if spare?(throwing, @next_throwing)
    add_foul if foul?(throwing)
    add_regular_frame(throwing) if regular_frame?(throwing, @next_throwing)
    score_cumsum
  end

  def add_strike
    add_score(10 + @next_throwing + @after_next_throwing)
    add_pinfalls('X', @next_throwing, @after_next_throwing) and return if last_frame?(@frame)
    add_pinfalls(' ', 'X')
  end

  def add_spare(throwing)
    add_score(10 + @after_next_throwing)
    add_pinfalls(throwing.to_s, '/')
    add_pinfalls(@after_next_throwing) if last_frame?(@frame)
    @skip_next = true
  end

  def add_foul
    add_pinfalls('F', @next_throwing)
    add_score(@next_throwing)
    @skip_next = true
  end

  def add_regular_frame(throwing)
    validate_frame_sum(throwing, @next_throwing)
    add_pinfalls(throwing, @next_throwing)
    add_score(throwing.to_i + @next_throwing)
    @skip_next = true
  end

  def add_score(score)
    @score_keeper.push(score)
  end

  def add_pinfalls(*frame_pinfalls)
    @pinfalls_keeper.push(*frame_pinfalls)
  end

  def score_cumsum
    @score_keeper[-1] += @score_keeper[-2].to_i
  end

  def reset_scoreboard
    @score_keeper = []
    @pinfalls_keeper = []
    @skip_next = false
    @frame = 0
  end

  def read_file(filename)
    IO.readlines(filename)
  end
end