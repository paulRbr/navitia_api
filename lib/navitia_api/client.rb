require 'navitia_api/authentication'
require 'navitia_api/configurable'
require 'navitia_api/connection'

module NavitiaApi

  # Client for the NAVITIA API
  #
  # @see https://api.sncf.com
  class Client

    include NavitiaApi::Authentication
    include NavitiaApi::Configurable
    include NavitiaApi::Connection

     # Header keys that can be passed in options hash to {#get},{#head}
    CONVENIENCE_HEADERS = Set.new([:accept, :content_type])

    def initialize(options = {})
      # Use options passed in, but fall back to module defaults
      NavitiaApi::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || NavitiaApi.instance_variable_get(:"@#{key}"))
      end
    end

    # Set access token for authentication
    #
    # @param value [String] 20 character NAVITIA API access token
    def access_token=(value)
      reset_agent
      @access_token = value
    end
  end

end
