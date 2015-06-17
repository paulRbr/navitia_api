require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'json'
require 'navitia_api'
require 'rspec'
require 'webmock/rspec'

WebMock.disable_net_connect!(:allow => 'coveralls.io')

require 'vcr'
VCR.configure do |c|
  c.configure_rspec_metadata!
  c.filter_sensitive_data("<<ACCESS_TOKEN>>") do
    test_token
  end
  c.default_cassette_options = {
    :serialize_with             => :json,
    :preserve_exact_body_bytes  => true,
    :decode_compressed_response => true,
    :record                     => ENV['TRAVIS'] ? :none : :once
  }
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

def navitia_url(url)
  return url if url =~ /^http/

  url = File.join(NavitiaApi.api_endpoint, url)
  uri = Addressable::URI.parse(url)

  uri.to_s
end

def token_client
  NavitiaApi::Client.new(:access_token => test_token)
end

def test_token
  ENV.fetch 'NAVITIA_TEST_TOKEN', 'x' * 20
end

def stub_get(url)
  stub_request(:get, navitia_url(url))
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def json_response(file)
  {
    :body => fixture(file),
    :headers => {
      :content_type => 'application/json; charset=utf-8'
    }
  }
end
