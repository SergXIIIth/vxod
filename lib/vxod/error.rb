module Vxod
  class Error
    def initialize(error = nil)
      @error = if error.is_a?(String)
        [error]
      else
        error
      end
    end

    # Array of errors. TODO rename to errors
    attr_accessor :error
    attr_accessor :success

    def success?
      error.nil?
    end

    def error?
      !success?
    end
  end
end