# frozen_string_literal: true

# This class is in charge of recording game frames one by one
class FrameRecorder
  attr_accessor :skip_next, :score_keeper, :pinfalls_keeper
  include Checkable
  include Validatable

  def initialize
    @score_keeper = []
    @pinfalls_keeper = []
    @skip_next = false
  end

  def record(throwing, next_throwing, after_next_throwing)
    assign_values(throwing, next_throwing, after_next_throwing)
    add_strike if strike?(throwing)
    add_spare if spare?(throwing, next_throwing)
    add_foul if foul?(throwing)
    add_regular_frame if regular_frame?(throwing, next_throwing)
    score_cumsum
  end

  def reset
    @score_keeper = []
    @pinfalls_keeper = []
    @skip_next = false
  end

  def frame_count
    @score_keeper.size
  end

  private

  def add_strike
    add_score(10 + @next_throwing + @after_next_throwing)
    add_pinfalls('X', @next_throwing, @after_next_throwing) && return if last_frame?(frame_count)
    add_pinfalls(' ', 'X')
  end

  def add_spare
    add_score(10 + @after_next_throwing)
    add_pinfalls(@throwing.to_s, '/')
    add_pinfalls(@after_next_throwing) if last_frame?(frame_count)
    @skip_next = true
  end

  def add_foul
    add_pinfalls('F', @next_throwing)
    add_score(@next_throwing)
    @skip_next = true
  end

  def add_regular_frame
    validate_frame_sum(@throwing, @next_throwing)
    add_pinfalls(@throwing, @next_throwing)
    add_score(@throwing.to_i + @next_throwing)
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

  def assign_values(throwing, next_throwing, after_next_throwing)
    @throwing = throwing
    @next_throwing = next_throwing
    @after_next_throwing = after_next_throwing
  end
end
