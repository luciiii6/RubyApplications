require 'faraday'
require './lib/show_command'
require './results/success'
require './results/failure'
require './lib/gem_api'

BASE_URL = 'https://rubygems.org/api/v1'

class ApiCall
  Faraday.default_adapter = :net_http

  class << self
    
    def show(name)
      url_completion = "/gems/#{name}.json"
      url = BASE_URL + url_completion
      response = Faraday.get(url)

      if response.status == 200
        Success.new(JSON.parse(response.body))
      else
        Failure.new({ 'message' => response.body })
      end
    end

    def search(query)
      url_completion = "/search.json?query=#{query}"
      url = BASE_URL + url_completion
      response = Faraday.get(url)

      if response.status == 200
        Success.new(JSON.parse(response.body))
      else
        Failure.new('message' => response.body)
      end 
    end
  end
end
