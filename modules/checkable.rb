# This module provides simple checking methods
module Checkable
  private

  def strike?(throwing)
    throwing.to_i == 10
  end

  def spare?(throwing, next_throwing)
    !strike?(throwing) && (throwing.to_i + next_throwing.to_i) == 10
  end

  def foul?(throwing)
    throwing == 'F'
  end

  def regular_frame?(throwing, next_throwing)
    throwings_sum = throwing.to_i + next_throwing.to_i
    !foul?(throwing) && throwings_sum < 10 && throwings_sum > 0
  end

  def last_frame?(frame)
    frame == 10
  end
end
