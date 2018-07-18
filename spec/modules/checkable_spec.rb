require 'spec_helper'

describe Checkable do
  let(:dummy_class) do
    Class.new do
      extend Checkable
    end
  end

  describe "#strike?" do
    context 'when throwing is equal to 10' do
      it 'should return true' do
        expect(dummy_class.send(:strike?, 10)).to be true
      end
    end
    context 'when throwing is different from 10' do
      it 'should return false' do
        expect(dummy_class.send(:strike?, 6)).to be false
      end
      it 'should return false' do
        expect(dummy_class.send(:strike?, -10)).to be false
      end
      it 'should return false' do
        expect(dummy_class.send(:strike?, 19)).to be false
      end
      it 'should return false' do
        expect(dummy_class.send(:strike?, 'F')).to be false
      end
    end
  end

  describe "#spare?" do
    context 'when the throwing and next throwing points add up 10' do
      it 'should return true' do
        expect(dummy_class.send(:spare?, 3, 7)).to be true
      end
    end
    context 'when the throwing and next throwing points does not add up 10' do
      it 'should return false' do
        expect(dummy_class.send(:spare?, 6, 7)).to be false
      end
      it 'should return false' do
        expect(dummy_class.send(:spare?, -10, -1)).to be false
      end
      it 'should return false' do
        expect(dummy_class.send(:spare?, 19, 0)).to be false
      end
      it 'should return false' do
        expect(dummy_class.send(:spare?, 'F', 3)).to be false
      end
    end
  end

  describe "#foul?" do
    context 'when the throwing is a foul' do
      it 'should return true' do
        expect(dummy_class.send(:foul?, 'F')).to be true
      end
    end
    context 'when the throwing is not a foul' do
      it 'should return false' do
        expect(dummy_class.send(:foul?, 2)).to be false
      end
      it 'should return false' do
        expect(dummy_class.send(:foul?, -10)).to be false
      end
      it 'should return false' do
        expect(dummy_class.send(:foul?, 1)).to be false
      end
    end
  end

  describe "#regular_frame?" do
    context 'when the throwing and next throwing points add up less than 10' do
      it 'should return true' do
        expect(dummy_class.send(:regular_frame?, 2, 3)).to be true
      end
    end
    context 'when the throwing and next throwing points does not add up less than 10' do
      it 'should return false' do
        expect(dummy_class.send(:regular_frame?, 2, 8)).to be false
      end
      it 'should return false' do
        expect(dummy_class.send(:regular_frame?, -2, -3)).to be false
      end
      it 'should return false' do
        expect(dummy_class.send(:regular_frame?, 'F', 10)).to be false
      end
    end
  end

  describe "#last_frame?" do
    context 'when frame is equal to 10' do
      it 'should return true' do
        expect(dummy_class.send(:last_frame?, 10)).to be true
      end
    end
    context 'when frame is not equal to 10' do
      it 'should return false' do
        expect(dummy_class.send(:last_frame?, 2)).to be false
      end
      it 'should return false' do
        expect(dummy_class.send(:last_frame?, -2)).to be false
      end
      it 'should return false' do
        expect(dummy_class.send(:last_frame?, 'F')).to be false
      end
    end
  end
end