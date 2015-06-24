require "api/default_options"

module NavitiaApi

  # Default configuration options for {Client}
  module Default

    # Default API endpoint
    API_ENDPOINT = "https://api.sncf.com".freeze

    # Default API version
    API_VERSION = "v1".freeze

    # Default User Agent header string
    USER_AGENT   = "Navitia API Ruby Gem #{NavitiaApi::VERSION}".freeze

    class << self

      include Api::DefaultOptions

      # Default access token from ENV
      # @return [String]
      def access_token
        ENV['NAVITIA_ACCESS_TOKEN']
      end

      # Default access token prefix
      # @return [String]
      def access_token_prefix
        ""
      end

      # Default API endpoint from ENV or {API_ENDPOINT}
      # @return [String]
      def api_endpoint
        ENV['NAVITIA_API_ENDPOINT'] || API_ENDPOINT
      end

      # Default API version from ENV or {API_VERSION}
      # @return [String]
      def api_version
        ENV['NAVITIA_API_VERSION'] || API_VERSION
      end

    # Default options for Faraday::Connection
      # @return [Hash]
      def connection_options
        {
          :headers => {
            :user_agent => user_agent
          }
        }
      end

      # Default User-Agent header string from ENV or {USER_AGENT}
      # @return [String]
      # Default User-Agent header string from ENV or {USER_AGENT}
      # @return [String]
      def user_agent
        ENV['NAVITIA_USER_AGENT'] || USER_AGENT
      end

    end
  end
end
