# frozen_string_literal: true

# This module provides methods to print out results to STDOUT
module Printable
  private

  def print_results(scoreboards)
    p format_output_line(10, 'Frame', (1..10).to_a)
    scoreboards.each do |player, scoreboard|
      p player
      p format_output_line(5, 'Pinfalls', scoreboard[:pinfalls])
      p format_output_line(10, 'Score', scoreboard[:scores])
    end
  end

  def print_errors
    @errors.uniq.each do |e|
      p e
    end
  end

  def format_output_line(space_quantity, first_col, array)
    array.inject(first_col.ljust(10)) { |formatted_line, value| formatted_line + value.to_s.ljust(space_quantity) }
  end
end
