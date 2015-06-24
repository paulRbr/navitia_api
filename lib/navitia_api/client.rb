require 'api/authentication'
require 'api/configurable'
require 'api/connection'

module NavitiaApi

  # Client for the NAVITIA API
  #
  # @see https://api.sncf.com
  class Client < Api::Client

    include Api::Authentication
    include Api::Configurable
    include Api::Connection

     # Header keys that can be passed in options hash to {#get}
    CONVENIENCE_HEADERS = Set.new([:accept, :content_type])

    # We redefine the inspect method from the Api gem because
    # of the kind of authentification of Navitia that considers
    # the username to be a secret key...
    # @return [String]
    def inspect
      inspected = super

      # mask basic_login
      inspected = inspected.gsub! @basic_login, "*******" if @basic_login
      inspected
    end

    # We redefine the basic_authenticated? method from the Api gem
    # again because the basic_password is blank as Navitia uses
    # the login as a secret key...
    #
    # @return [Boolean]
    def basic_authenticated?
      !@basic_login.nil? && !@basic_login.empty?
    end

  end
end
