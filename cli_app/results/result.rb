class Result
  attr_reader :data
  
  def initialize(data)
    @data = data
  end

  def data=(data)
    @data = data
  end

  def success?
    raise NotImplementedError
  end
end