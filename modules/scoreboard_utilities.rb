module ScoreboardUtilities

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
end