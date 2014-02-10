require 'spec_helper'

describe Edmodo::API::Client do

  let(:client){
    Edmodo::API::Client.new( Edmodo )
  }


  describe 'initialization' do
    describe 'via configure' do
      it "should be initialized by config" do
        set_testing_configuration
        cli = Edmodo.configure do |c |
              c.api_key  = edmodo_api_key
              c.testing  = true
        end
        cli.should_not be nil?
        options_hash = cli.class.default_options
        options_hash[:base_uri].should == Edmodo.api_url
        options_hash[:default_params].should_not == nil
        options_hash[:default_params]['api_key'].should == edmodo_api_key
        options_hash[:debug_output].should_not == nil
        options_hash[:headers].should_not == nil
        options_hash[:headers]['User-Agent'].should_not == nil
      end
    end

    it 'should be initialized via hash' do
      configuration_hash = {
          endpoint:    'https://example.com',
          api_version: 'v52',
          api_key:     'my_edmodo_api_key',
          testing:      true
      }
      client = Edmodo::API::Client.new( configuration_hash )
      client.should_not be nil
      options_hash = client.class.default_options
      options_hash[:base_uri].should == 'https://example.com/v52'
      options_hash[:default_params].should_not == nil
      options_hash[:default_params]['api_key'].should == configuration_hash[:api_key]
      options_hash[:debug_output].should_not == nil
    end
  end

  describe 'build_get_options' do
    before(:each) do
        set_testing_configuration
      end

    it "should raise InvalidCredentials if api key has not been set" do
      Edmodo.api_key = nil
      expect{
        Edmodo::API::Client.new( Edmodo )
      }.to raise_error Edmodo::InvalidCredentials, /Api Key/
    end

    it "should NOT raise InvalideCredentials if access_token is not present with API v1" do
      expect{
        Edmodo.api_version='v1'
        client.build_get_options()
      }.to_not raise_error
    end

    it "should raise InvalidCredentials if access_token param is not present with API v1.1" do
      expect{
        Edmodo.api_version = 'v1.1'
        client.build_get_options()
      }.to raise_error Edmodo::InvalidCredentials, /:access_token/
    end
  end

  describe "get" do
    #
    # Because of the conflict of Excon.stubs with VCR (they do not work at the same time)
    # We created a errors.yml file by hand to simulate stubs that always return the desired error code
    #
    before(:each){
      Edmodo.api_version = 'v1' #these are error call tests, no need for access tokens
    }

    it "should not raise an exception with response status 200" do
      VCR.use_cassette("errors") do
        expect{ client.get("/200") }.not_to raise_error
      end
    end
    it "should raise Edmodo::BadRequest with response status is 400" do
      VCR.use_cassette("errors") do
        expect{ client.get("/400") }.to raise_error  Edmodo::BadRequest
      end
    end
    it "should raise Edmodo::AuthenticationFailed with response status is 401" do
      VCR.use_cassette("errors") do
        expect{ client.get("/401") }.to raise_error  Edmodo::AuthenticationFailed
      end
    end
    it "should raise Edmodo::NotFound with response status is 404" do
      VCR.use_cassette("errors") do
        expect{ client.get("/404") }.to raise_error  Edmodo::NotFound
      end

    end
    it "should raise Edmodo::ServerError with response status is 500" do
      VCR.use_cassette("errors") do
        expect{ client.get("/500") }.to raise_error  Edmodo::ServerError
      end
    end
    it "should raise Edmodo::Unavailable with response status is 502" do
      VCR.use_cassette("errors") do
        expect{ client.get("/502") }.to raise_error  Edmodo::Unavailable
      end
    end
    it "should raise Edmodo::RateLimited. with response status is 503" do
      VCR.use_cassette("errors") do
        expect{ client.get("/503") }.to raise_error  Edmodo::RateLimited
      end
    end
    it "should raise Edmodo::UnknownStatusCode. with response status is not listed above" do
      VCR.use_cassette("errors") do
        expect{ client.get("/499") }.to raise_error  Edmodo::UnknownStatusCode
      end
    end
  end
end