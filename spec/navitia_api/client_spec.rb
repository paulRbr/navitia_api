require 'spec_helper'
require 'json'

describe NavitiaApi::Client do

  before do
    NavitiaApi.reset!
  end

  after do
    NavitiaApi.reset!
  end

  describe "module configuration" do

    before do
      NavitiaApi.reset!
      NavitiaApi.configure do |config|
        Api::Configurable.keys.each do |key|
          config.send("#{key}=", "Some #{key}")
        end
      end
    end

    after do
      NavitiaApi.reset!
    end

    it "inherits the module configuration" do
      client = NavitiaApi.client
      Api::Configurable.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq("Some #{key}")
      end
    end

    describe "with class level configuration" do

      before do
        @opts = {
          :connection_options => {:ssl => {:verify => false}},
          :access_token => "il0veruby"
        }
      end

      it "overrides module configuration" do
        client = NavitiaApi::Client.new(@opts)
        expect(client.instance_variable_get(:"@access_token")).to eq("il0veruby")
        expect(client.connection_options[:ssl][:verify]).to be(false)
      end

      it "can set configuration after initialization" do
        client = NavitiaApi::Client.new
        client.configure do |config|
          @opts.each do |key, value|
            config.send("#{key}=", value)
          end
        end
        expect(client.instance_variable_get(:"@access_token")).to eq("il0veruby")
      end

      it "masks tokens on inspect" do
        client = NavitiaApi::Client.new(:access_token => 'token123')
        inspected = client.inspect
        expect(inspected).not_to include("token123")
      end

      it "masks basic login on inspect" do
        client = NavitiaApi::Client.new(:basic_login => 'loginwhichisactuallyapassword')
        inspected = client.inspect
        expect(inspected).not_to include("loginwhichisactuallyapassword")
      end
    end
  end

  describe "authentication" do
    before do
      NavitiaApi.reset!
      @client = NavitiaApi.client
    end

    describe "with module level config" do
      before do
        NavitiaApi.reset!
      end
      it "sets token with .configure" do
        NavitiaApi.configure do |config|
          config.access_token = 'token123'
          config.basic_login = 'login'
          config.basic_password = ''
        end
        expect(NavitiaApi.client).to be_token_authenticated
        expect(NavitiaApi.client).to be_basic_authenticated
      end
      it "sets token with module methods" do
        NavitiaApi.access_token = 'token123'
        expect(NavitiaApi.client).to be_token_authenticated
      end
    end

    describe "with class level config" do
      it "sets token with instance methods" do
        @client.access_token = 'token123'
        @client.basic_login = 'login'
        expect(@client).to be_token_authenticated
        expect(@client).to be_basic_authenticated
      end
    end

    describe "when basic authenticated", :vcr do
      it "makes authenticated calls" do
        client = basic_auth_client

        stops_request = stub_get("/", { :basic_login => client.basic_login })
          .and_return(:status => 200)
        client.get("/")
        assert_requested stops_request
      end
    end
  end

  describe ".agent" do
    before do
      NavitiaApi.reset!
    end
    it "acts like a Sawyer agent" do
      expect(NavitiaApi.client.agent).to respond_to :start
    end
    it "caches the agent" do
      agent = NavitiaApi.client.agent
      expect(agent.object_id).to eq(NavitiaApi.client.agent.object_id)
    end
  end # .agent

  describe ".root" do
    it "fetches the API root" do
      NavitiaApi.reset!
      VCR.use_cassette 'root' do
        expect {
          NavitiaApi.client.root
        }.to_not raise_error
        expect(NavitiaApi.client.last_response.data[:links].count).to be(3)
      end
    end
  end

  describe ".last_response", :vcr do
    before do
      NavitiaApi.client.instance_variable_set(:@last_response, nil)
    end

    it "caches the last agent response" do
      NavitiaApi.reset!
      expect(NavitiaApi.client.last_response).to be_nil
      NavitiaApi.client.get "/"
      expect(NavitiaApi.client.last_response.status).to eq(200)
    end
  end # .last_response

  describe ".get", :vcr do
    before(:each) do
      NavitiaApi.reset!
    end
    it "handles query params" do
      NavitiaApi.client.get "/", :foo => "bar"
      assert_requested :get, "https://api.sncf.com/v1/?foo=bar"
    end
    it "handles headers" do
      request = stub_get("/").
        with(:query => {:foo => "bar"}, :headers => {:accept => "text/plain"})
      NavitiaApi.client.get "/", :foo => "bar", :accept => "text/plain"
      assert_requested request
    end
  end # .get

  describe "when making requests" do
    before do
      VCR.turn_off!
      NavitiaApi.reset!
      @client = NavitiaApi.client
    end
    after do
      VCR.turn_on!
    end

    it "sets a default user agent" do
      root_request = stub_get("/").
        with(:headers => {:user_agent => NavitiaApi::Default.user_agent})
      @client.get "/"
      assert_requested root_request
      expect(@client.last_response.status).to eq(200)
    end
    it "sets a custom user agent" do
      user_agent = "Mozilla/5.0 I am Spartacus!"
      root_request = stub_get("/").
        with(:headers => {:user_agent => user_agent})
      NavitiaApi.configure do |c|
        c.user_agent = user_agent
      end
      expect(NavitiaApi.client.user_agent).to eq(user_agent)
      NavitiaApi.client.get "/"
      assert_requested root_request
      expect(NavitiaApi.client.last_response.status).to eq(200)
    end
  end

  context "error handling" do
    before do
      NavitiaApi.reset!
      VCR.turn_off!
    end

    after do
      VCR.turn_on!
    end

    it "raises on 404" do
      stub_get('/booya').to_return(:status => 404)
      expect { NavitiaApi.get('/booya') }.to raise_error Api::NotFound
    end

    it "raises on 401" do
      stub_get('/forbidden').to_return(:status => 401)
      expect { NavitiaApi.get('/forbidden') }.to raise_error Api::Unauthorized
    end

    it "raises on 500" do
      stub_get('/boom').to_return(:status => 500)
      expect { NavitiaApi.get('/boom') }.to raise_error Api::InternalServerError
    end
  end
end
