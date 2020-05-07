module TpagaService
  module Swagger
    class Configuration
      #attr_accessor :format, :api_key, :api_key_prefix, :username, :password, :auth_token, :scheme, :host, :base_path, :user_agent, :logger, :inject_format, :force_ending_format, :camelize_params, :user_agent, :verify_ssl
      attr_accessor :format, :scheme, :host, :base_path, :private_api_key, :public_api_key, :inject_format

      # Defaults go in here..
      def initialize
        @format = 'json'
        @scheme = 'https'
        @host = 'sandbox.tpaga.co'
        @base_path = '/api'
        #@user_agent = "ruby-swagger-#{Swagger::VERSION}"
        @inject_format = false
        #@force_ending_format = false
        #@camelize_params = true

        # keys for API key authentication (param-name => api-key)
        @private_api_key = 'njba5fp5v3lserbeg9nikible8mstn8s'
        @public_api_key = 'e8tbtu6bdi1bae34h9nkipschq9heq0a'
        # api-key prefix for API key authentication, e.g. "Bearer" (param-name => api-key-prefix)
        #@api_key_prefix = {}

        # whether to verify SSL certificate, default to true
        # Note: do NOT set it to false in production code, otherwise you would
        #   face multiple types of cryptographic attacks
        @verify_ssl = true
      end
    end
  end
end
