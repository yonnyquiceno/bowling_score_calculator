# frozen_string_literal: true

# This class is in charge of reading input text files
class FileReader
  def initialize(filename)
    @filename = filename
  end

  def read_file
    IO.readlines(@filename)
  end
end
