require 'optparse'

class SearchOptionsParser
  class << self
    def parse
      options = {}
      optparse = OptionParser.new do |opts|
        opts.on('--license LICENSE', 'Show the gem information') do |license|
            options[:license] = license
        end
        opts.on('--most-downloads-first', 'Show gems found by entered text') do
            options[:downloads] = true
        end
      end
      optparse.parse!
      options

    end   
  end
end
