require 'sinatra/base'

module Vxod
end

files = %w(
  version
  rack_app_wrap
  config
  api
  api_static
  middleware
)

files.each { |file| require "vxod/#{file}" }


# wildcards = %w(

#   **/*.rb
# )

# wildcards.each do |wildcard|
#   file_search_pattern = File.dirname(__FILE__) + '/vxod/' + wildcard
#   Dir.glob(file_search_pattern).each { |file| require file }
# end



