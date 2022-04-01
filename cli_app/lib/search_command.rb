require './lib/api_call'
require './lib/help_search_command'
require './lib/info_result'
require './lib/search_options_parser'
require './lib/gem_api'

class SearchCommand

  class SearchResult
    attr_reader :gem_list
    def initialize(list)
      @gem_list = list
    end
  end

  class << self
    def create(args)
      return HelpSearchCommand.new if args.empty?
      args = removeOptions(args)
      options = SearchOptionsParser.parse
      new(args.length > 1 ? to_s_query(args) : args[0], options)
    end

    def to_s_query(query)
      string_query = ''
      query.each{ |str| string_query+="+#{str}" }
      string_query[1..]
    end

    def removeOptions(args)
      index = args.find_index { |arg| arg.start_with?('--')}
      return args[0..index - 1] if index
      args
    end

  end

  attr_reader :query, :options
  def initialize(query, options = {})
    @query = query
    @options = options
  end

  def filter(result)
    case @options.length
    when 0
      return result.data.map { |gem| GemApi.new(gem['name'], gem['info'], gem['version']) }
    when 1
      if @options[:downloads]
        return result.data.sort_by { |gem| gem['downloads'].to_i }.reverse.map { |gem| GemApi.new(gem['name'], gem['info'], gem['version']) }
      elsif @options[:license]
        return result.data.filter_map { |gem| GemApi.new(gem['name'], gem['info'], gem['version']) if gem['licenses'].is_a?(Array) && gem['licenses'].include?(options[:license]) }
      end
    when 2
      return result.data.sort_by { |gem| gem['downloads'].to_i }.reverse.filter_map { |gem| GemApi.new(gem['name'], gem['info'], gem['version']) if gem['licenses'].is_a?(Array) && gem['licenses'].include?(options[:license]) }
    end
    

  end
  def result
    result = ApiCall.search(@query)
    if result.success?
      result.data = filter(result)
      return InfoResult.new('No results found after filtering') unless result.data.length != 0
      return SearchResult.new(result.data)
    end

    InfoResult.new(result.data['message'])
  end
end
