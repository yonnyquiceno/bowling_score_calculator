# This module has all the methods involved in scoreboard calculations for each player
module Calculable
  include Checkable

  def throwings_by_player(raw_throwings)
    raw_throwings.each_with_object({}) do |score_line, separated_throwings|
      next if score_line.strip == '' # prevent errors by empty lines
      player_name, throw_score = score_line.strip.split(' ') # turns 'Jeff 10' into ['Jeff', '10']
      separated_throwings[player_name] ||= []
      separated_throwings[player_name] << throw_score
    end
  end

  def scoreboards(separated_throwings)
    separated_throwings.each_with_object({}) do |player_throwings, scoreboards|
      pinfalls, scores = player_scoreboard(player_throwings[1])
      scoreboards[player_throwings[0]] = { pinfalls: pinfalls, scores: scores }
    end
  end

  def player_scoreboard(player_throwings)
    @score_keeper = []
    @pinfalls_keeper = []
    @skip_next = false
    player_throwings.each_with_index do |throwing, idx|
      break if @score_keeper.size == 10
      if @skip_next
        @skip_next = false
        next
      end
      @next_throwing = player_throwings[idx + 1].to_i
      @after_next_throwing = player_throwings[idx + 2].to_i
      @frame = @score_keeper.size
      record_frame(throwing)
      cumulate_score
    end
    validate_frame_count(@score_keeper.size)
    [@pinfalls_keeper, @score_keeper]
  end

  def record_frame(throwing)
    add_strike if strike?(throwing)
    add_spare(throwing) if spare?(throwing, @next_throwing)
    add_foul if foul?(throwing)
    add_regular_frame(throwing) if regular_frame?(throwing, @next_throwing)
  end

  def cumulate_score
    @score_keeper[-1] += @score_keeper[-2].to_i
  end

  def add_score(score)
    @score_keeper.push(score)
  end

  def add_pinfalls(*frame_pinfalls)
    @pinfalls_keeper.push(*frame_pinfalls)
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
end
