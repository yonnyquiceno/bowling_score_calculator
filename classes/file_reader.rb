class FileReader

  def initialize(filename)
    @filename = filename
  end

  def read_file
    IO.readlines(@filename)
  end
end
