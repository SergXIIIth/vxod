require 'vxod/version'
require 'sinatra/base'

wildcards = %w(
  **/*.rb
)

wildcards.each do |wildcard|
  file_search_pattern = File.dirname(__FILE__) + '/vxod/' + wildcard
  Dir.glob(file_search_pattern).each { |file| require file }
end

module Vxod
  class << self
    def new_instance(rack_app)
      Vxod::Instance.new(rack_app)
    end
  end
end


