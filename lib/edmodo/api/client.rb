require 'hashie/rash'

module Edmodo
  module API
    class Client
      include HTTParty

      # initialize
      #
      # The Edmodo Api Client can be configured via Edmodo.configure block
      # or via a hash with the appropriate values set
      #
      # endpoint:     required. The API endpoing i.e https://appsapi.edmodo.com
      # api_version:  required. The API version (v1 or V1.1)
      # api_key:      required. Your edmodo api key
      # timeout:      optional. The HTTP timeout
      # testing:      optional. Set it to true to activate debugging output
      #
      # @param configuration [Edmodo or Hash] A hash or Edmodo::Configuration that contains the parameters to
      #     be used when issuing HTTP Calls
      def initialize( configuration )

        if configuration.is_a?(Module) && configuration.to_s == 'Edmodo'
          config = configuration
        elsif configuration.is_a?(Hash)
          config = Hashie::Rash.new( configuration )
          config.api_url = [config.endpoint,config.api_version].join('/')
        end

        if config.api_key
          self.class.default_params({ 'api_key' => config.api_key})
        else
          raise Edmodo::InvalidCredentials.new("Api Key is not present but it is required.")
        end

        self.class.base_uri( config.api_url )                     if config.api_url
        self.class.default_timeout config.timeout.to_f            if config.timeout
        self.class.debug_output                                   if config.testing
        self.class.headers({'User-Agent' => config.user_agent})   if config.user_agent
      end

      # get
      # send an HTTPS Get request against Edmodos's API.
      # Yields the get_options before sending making the request.
      #
      #
      # @param path    [String] The path for the api endpoint (with leading slash)
      # @param params  [Hash]   A hash of query arguments for the request (optional)
      # @param headers [Hash]   A hash of header fields (optional).
      #
      #
      # @return [String]. The raw response body (JSON is expected) Raises appropriate exception if it fails
      # @raise Edmodo::HTTPError when any HTTP error response is received
      def get( path, params={}, headers={})
        get_options = build_get_options( params, headers)
        yield get_options if block_given?

        #puts "CALLING API: #{Edmodo.api_url( path )} ===#{get_options}"
        response = self.class.get( path, get_options)

        handle_response(response, params)
      end

      # post
      # send an HTTPS post request against Edmodos's API.
      #
      #
      # @param path    [String] The path for the api endpoint (with leading slash)
      # @param params  [Hash]   A hash of query arguments for the request (optional)
      # @param headers [Hash]   A hash of header fields (optional).
      #
      #
      # @return [String]. The raw response body (JSON is expected) Raises appropriate exception if it fails
      # @raise Edmodo::HTTPError when any HTTP error response is received
      def post( path, body={}, headers={} )
        #puts "CALLING API: #{Edmodo.api_url( path )} ===#{post_options}"
        response = self.class.post( path, { body: body.to_json, headers: headers })

        handle_response(response, body)
      end

      # build_get_options
      # Build the hash of options for an HTTP get request.
      #
      # @param params  [Hash] optional. Any query parameters to add to the request.
      # @param user_headers [Hash] optional. Any query parameters to add to the request.
      #
      # @return [Hash] The properly formated get_options.
      # @raise [Edmodo::InvalidCredentials] if the access_token is required but not supplied in the params API v1.1
      def build_get_options( params={}, user_headers={})
        get_options = {}
        query = {}

        # Add the access token
        query[:access_token] = params[:access_token] if params[:access_token]
        # if Edmodo.access_token_required?
        #   raise Edmodo::InvalidCredentials.new(" :access_token query parameter required when using API version #{Edmodo.api_version}") if params[:access_token].nil? || params[:access_token].empty?
        #   query[:access_token] = params[:access_token] if params[:access_token]
        # end
        query.merge!(params)
        get_options[:query]   = query

        # pass any headers
        headers ={}
        headers.merge!( user_headers )
        get_options[:headers] = headers

        get_options
      end

      # # build_post_options
      # # Build the hash of options for an HTTP post request.
      # #
      # # @param params  [Hash] optional. Any query parameters to add to the request.
      # # @param params  [Hash] optional. Any data included with the request.
      # # @param user_headers [Hash] optional. Any query parameters to add to the request.
      # #
      # # @return [Hash] The properly formated post_options.
      # # @raise [Edmodo::InvalidCredentials] if the access_token is required but not supplied in the params API v1.1
      # def build_post_options( params={}, body={}, user_headers={})
      #   post_options = {}
      #   query = {}

      #   # Add the access token
      #   query[:access_token] = params[:access_token] if params[:access_token]
      #   # if Edmodo.access_token_required?
      #   #   raise Edmodo::InvalidCredentials.new(" :access_token query parameter required when using API version #{Edmodo.api_version}") if params[:access_token].nil? || params[:access_token].empty?
      #   #   query[:access_token] = params[:access_token] if params[:access_token]
      #   # end
      #   query.merge!(params)
      #   post_options[:query] = query

      #   # pass any headers
      #   headers ={}
      #   headers.merge!( user_headers )
      #   post_options[:headers] = headers

      #   post_options
      # end


      private
      #========================================================================

      def handle_response(response, params)
        case response.code
          when 200..201
            response
          when 400
            raise Edmodo::BadRequest.new(response, params)
          when 401
            raise Edmodo::AuthenticationFailed.new(response, params)
          when 404
            raise Edmodo::NotFound.new(response, params)
          when 500
            raise Edmodo::ServerError.new(response, params)
          when 502
            raise Edmodo::Unavailable.new(response, params)
          when 503
            raise Edmodo::RateLimited.new(response, params)
          else
            raise Edmodo::UnknownStatusCode.new(response, params)
        end
      end

    end
  end
end
