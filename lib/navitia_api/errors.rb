module NavitiaApi

  # All errors from this gem will inherit from this one.
  class Error < StandardError
    # Returns the appropriate NavitiaApi::Error subclass based
    # on status and response message
    #
    # @param [Hash] response HTTP response
    # @return [NavitiaApi::Error]
    def self.from_response(response)
      status  = response[:status].to_i
      body    = response[:body].to_s
      headers = response[:response_headers]

      if klass =  case status
                  when 400      then NavitiaApi::BadRequest
                  when 401      then NavitiaApi::Unauthorized
                  when 403      then NavitiaApi::Unauthorized
                  when 404      then NavitiaApi::NotFound
                  when 405      then NavitiaApi::MethodNotAllowed
                  when 406      then NavitiaApi::NotAcceptable
                  when 409      then NavitiaApi::Conflict
                  when 415      then NavitiaApi::UnsupportedMediaType
                  when 422      then NavitiaApi::UnprocessableEntity
                  when 400..499 then NavitiaApi::ClientError
                  when 500      then NavitiaApi::InternalServerError
                  when 501      then NavitiaApi::NotImplemented
                  when 502      then NavitiaApi::BadGateway
                  when 503      then NavitiaApi::ServiceUnavailable
                  when 500..599 then NavitiaApi::ServerError
                  end
        klass.new(response)
      end
    end

    def initialize(response=nil)
      @response = response
      super(build_error_message)
    end
  end

  class ClientError < Error; end
  class BadRequest < ClientError; end
  class Unauthorized < ClientError; end
  class Unauthorized < ClientError; end
  class NotFound < ClientError; end
  class MethodNotAllowed < ClientError; end
  class NotAcceptable < ClientError; end
  class Conflict < ClientError; end
  class UnsupportedMediaType < ClientError; end
  class UnprocessableEntity < ClientError; end
  class InternalServerError < ClientError; end
  class NotImplemented < ClientError; end
  class BadGateway < ClientError; end
  class ServiceUnavailable < ClientError; end
  class ServerError < ClientError; end

end
