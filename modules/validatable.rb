# This module contains the methods that performs validations over the input data
module Validatable
  private

  def validate_game(throwings_by_player)
    @errors ||= []
    throwings_by_player.each do |player, throwings|
      @errors << I18n.t('errors.player_game_incomplete', player: player) if throwings.size < 10
      throwings.each do |throw_score|
        validate_score(throw_score)
      end
    end
    raise 'InputError' unless @errors.empty?
  end

  def validate_score(score)
    @errors ||= []
    @errors << I18n.t('errors.invalid_char', score: score) unless valid_chars?(score)
    @errors << I18n.t('errors.no_negative_values') if score.to_i < 0
    @errors << I18n.t('errors.should_not_be_major_than_10') if score.to_i > 10
    @errors
  end

  def validate_frame_sum(throw1, throw2)
    @errors ||= []
    if throw1.to_i + throw2.to_i > 10
      @errors << I18n.t('errors.should_not_be_major_than_10')
      raise 'InputError'
    end
  end

  def validate_frame_count(frame_count)
    @errors ||= []
    if frame_count < 10
      @errors << I18n.t('errors.game_incomplete')
      raise 'InputError'
    end
  end

  def valid_chars?(score)
    !!(score.to_s =~ /^(-{0,1}\d+|F)$/) # Regexp to match 
  end
end
