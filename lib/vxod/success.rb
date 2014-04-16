module Vxod
  class Success
    def initialize(message = nil)
      @error = nil
    end

    attr_accessor :error
    attr_accessor :success

    def success?
      error.nil?
    end
  end
end