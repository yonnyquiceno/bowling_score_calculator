require 'spec_helper'

describe Checkable do
  let(:dummy_class) do
    Class.new do
      extend Checkable
    end
  end
end