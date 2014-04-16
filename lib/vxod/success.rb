module Vxod
  class Success < Error
    def initialize(success = nil)
      @error = nil
      @success = success
    end
  end
end