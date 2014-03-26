module CustomHelpers
  def rnd(text = nil)
    CustomHelpers.rnd(text)
  end

  # rnd -> 1,5,7
  # rnd('key') -> key 1, key 5, key 7 
  def self.rnd(text = nil)
    rnd = Random.rand(10000)
    if text.nil?
      rnd
    else
      "#{text}_#{rnd}"
    end
  end
end