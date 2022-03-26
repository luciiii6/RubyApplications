require './lib/api_call'
require './lib/help_show_command'
require './lib/info_result'

class ShowCommand

  class ShowResult
    attr_reader :name, :info

    def initialize(name, info)
      @name = name
      @info = info
    end
  end

  class << self
    def create(args)
      return HelpShowCommand.new if args.empty?

      new(args.first)

    end
  end

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def result
    result = ApiCall.show(@name)

    if result.success?
      return ShowResult.new(result.data['name'], result.data['info'])
    end

    InfoResult.new(result.data['message'])
    # case status
    # when :success
    #   ShowResult.new(data['name'], data['info'])
    # when :error
    #   InfoResult.new(data['message'])
    # end
  end
  # def result
  #   status, data = ApiCall.show(@name)

  #   case status
  #   when :success
  #     ShowResult.new(data['name'], data['info'])
  #   when :error
  #     InfoResult.new(data['message'])
  #   end
  # end
end
