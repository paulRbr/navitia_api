require 'faraday'
require 'navitia_api/errors'

module NavitiaApi
  # Faraday response middleware
  module Response

    # This class raises an NavitiaApi-flavored exception based
    # HTTP status codes returned by the API
    class RaiseError < Faraday::Response::Middleware

      private

      def on_complete(response)
        if error = NavitiaApi::Error.from_response(response)
          raise error
        end
      end
    end
  end
end
