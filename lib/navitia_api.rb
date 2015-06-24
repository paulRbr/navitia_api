$LOAD_PATH.unshift(File.dirname(__FILE__)) unless
  $LOAD_PATH.include?(File.dirname(__FILE__)) || $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'json'

require 'api'

require 'navitia_api/default'
require 'navitia_api/client'
#require 'navitia_api/base'
#require 'navitia_api/stop'
#require 'navitia_api/fare'
require 'navitia_api/version'


# Ruby toolkit for the NAVITIA API
module NavitiaApi

  class << self

    include Api::Configurable

    # API client based on configured options {Configurable}
    #
    # @return [NavitiaApi::Client] API wrapper
    def client
      return @client if defined?(@client) && @client.same_options?(options)
      @client = NavitiaApi::Client.new(options)
    end

    private

    def respond_to_missing?(method_name, include_private = false)
      client.respond_to?(method_name, include_private)
    end

    def method_missing(method_name, *args, &block)
      if client.respond_to?(method_name)
        return client.send(method_name, *args, &block)
      end

      super
    end

  end
end

NavitiaApi.reset!
