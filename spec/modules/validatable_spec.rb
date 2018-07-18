require 'spec_helper'

describe Validatable do
  let(:valid_throwings) {
    {
      "John": %w(3 7 6 3 10 8 1 10 10 9 0 7 3 4 4 10 9 0),
      "Jeff": %w(10 7 3 9 0 10 0 8 8 2 F 6 10 10 10 8 1)
    }
  }
  let(:invalid_throwings) {
    {
      "John": %w(3 7 6 3 10 8 -2 10 10 9 0 7 3 4 4 10 9 0),
      "Jeff": %w(10 7 3 9 0 10 0 8 8 2 F 6 10 10 10 8 1)
    }
  }
  let(:dummy_class) do
    Class.new do
      extend Validatable
    end
  end

  describe "#validate_game" do
    context 'when game is valid' do
      it 'should return nil' do
        expect(dummy_class.send(:validate_game, valid_throwings)).to be_nil
      end
    end
    context 'when game is not valid' do
      it 'should raise RuntimeError' do
        expect{ dummy_class.send(:validate_game, invalid_throwings) }.to raise_error(RuntimeError)
      end
    end
  end

  describe "#validate_score" do
    before do
      @errors = nil
    end
    context 'when score is valid' do
      it 'should returns an empty array' do
        expect(dummy_class.send(:validate_score, 1)).to eq([])
      end
      it 'should return nil' do
        expect(dummy_class.send(:validate_score, 10)).to eq([])
      end
      it 'should return nil' do
        expect(dummy_class.send(:validate_score, 'F')).to eq([])
      end
      it 'should return nil' do
        expect(dummy_class.send(:validate_score, 0)).to eq([])
      end
    end
    context 'when score is not an integer, a character different than \'F\' or a number major than 10' do
      it 'should return an array with the related error' do
        expect(dummy_class.send(:validate_score, '440'))
        .to eq([I18n.t('errors.should_not_be_major_than_10')])
      end
      it 'should return an array with the related error' do
        expect(dummy_class.send(:validate_score, '-11'))
        .to eq([I18n.t('errors.no_negative_values')])
      end
      it 'should return an array with the related error' do
        expect(dummy_class.send(:validate_score, 'Z'))
        .to eq([I18n.t('errors.invalid_char', score: 'Z')])
      end
      it 'should return an array with the related error' do
        expect(dummy_class.send(:validate_score, 'f'))
        .to eq([I18n.t('errors.invalid_char', score: 'f')])
      end
    end
  end

  describe '#validate_frame_sum' do
    context 'when frame sum add up less than 11' do
      it 'returns nil' do
        expect(dummy_class.send(:validate_frame_sum, 3, 7 )).to be_nil
      end
      it 'returns nil' do
        expect(dummy_class.send(:validate_frame_sum, 3, 2 )).to be_nil
      end
    end
    context 'when frame sum add up more than 10' do
      it 'should raise a RuntimeError' do
        expect{ dummy_class.send(:validate_frame_sum, 3, 8 ) }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#validate_frame_count' do
    context 'when frame count is minor than 10' do
      it 'should raise a RuntimeError' do
        expect{ dummy_class.send(:validate_frame_count, 3) }.to raise_error(RuntimeError)
      end
    end
    context 'when frame count is 10' do
      it 'should return nil' do
        expect(dummy_class.send(:validate_frame_count, 10)).to be_nil
      end
    end
  end

  describe '#valid_chars?' do
    context 'when the character is valid' do
      it 'should return true' do
        expect(dummy_class.send(:valid_chars?, 10)).to be true
      end
      it 'should return true' do
        expect(dummy_class.send(:valid_chars?, "F")).to be true
      end
      it 'should return true' do
        expect(dummy_class.send(:valid_chars?, 2)).to be true
      end
    end
    context 'when the character is not valid' do
      it 'should return false' do
        expect(dummy_class.send(:valid_chars?, 'f')).to be false
      end
      it 'should return true' do
        expect(dummy_class.send(:valid_chars?, 1.6)).to be false
      end
      it 'should return true' do
        expect(dummy_class.send(:valid_chars?, 'Z')).to be false
      end
    end
  end
end