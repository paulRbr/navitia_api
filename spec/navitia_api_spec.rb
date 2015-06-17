require 'spec_helper'

describe NavitiaApi do
  before do
    NavitiaApi.reset!
  end

  after do
    NavitiaApi.reset!
  end

  it "sets defaults" do
    NavitiaApi::Configurable.keys.each do |key|
      expect(NavitiaApi.instance_variable_get(:"@#{key}")).to eq(NavitiaApi::Default.send(key))
    end
  end

  describe "::client" do
    it "creates an NavitiaApi::Client" do
      expect(NavitiaApi.client).to be_kind_of NavitiaApi::Client
    end
    it "caches the client when the same options are passed" do
      expect(NavitiaApi.client).to eq(NavitiaApi.client)
    end
    it "returns a fresh client when options are not the same" do
      client = NavitiaApi.client
      NavitiaApi.access_token = "87614b09dd141c22800f96f11737ade5226d7ba8"
      client_two = NavitiaApi.client
      client_three = NavitiaApi.client
      expect(client).not_to eq(client_two)
      expect(client_three).to eq(client_two)
    end
  end

  describe ".configure" do
    NavitiaApi::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        NavitiaApi.configure do |config|
          config.send("#{key}=", key)
        end
        expect(NavitiaApi.instance_variable_get(:"@#{key}")).to eq(key)
      end
    end
  end

end
