#require 'logger'
require 'json'

module TpagaService
  module Swagger
    class << self
      # attr_accessor :logger

      # A Swagger configuration object. Must act like a hash and return sensible
      # values for all Swagger configuration options. See Swagger::Configuration.
      attr_accessor :configuration

      # Call this method to modify defaults in your initializers.
      #
      # @example
      #   Swagger.configure do |config|
      #     config.private_api_key = '1234567890abcdef'     # private api key authentication
      #     config.public_api_key  = '9876543210fedcba'     # public api key authentication
      #     config.format = 'json'                  # optional, defaults to 'json'
      #   end
      #
      def configure
        yield(configuration) if block_given?

        # Configure logger.  Default to use Rails
        # self.logger ||= configuration.logger || (defined?(Rails) ? Rails.logger : Logger.new(STDOUT))

        # remove :// from scheme
        # configuration.scheme.sub!(/:\/\//, '')

        # remove http(s):// and anything after a slash
        configuration.host.sub!(/https?:\/\//, '')
        configuration.host = configuration.host.split('/').first

        # Add leading and trailing slashes to base_path
        configuration.base_path = "/#{configuration.base_path}".gsub(/\/+/, '/')
        configuration.base_path = "" if configuration.base_path == "/"
      end

      # def authenticated?
      #   Swagger.configuration.auth_token.present?
      # end
      #
      # def de_authenticate
      #   Swagger.configuration.auth_token = nil
      # end
      #
      # def authenticate
      #   return if Swagger.authenticated?
      #
      #   if Swagger.configuration.username.blank? || Swagger.configuration.password.blank?
      #     raise ClientError, "Username and password are required to authenticate."
      #   end
      #
      #   request = Swagger::Request.new(
      #       :get,
      #       "account/authenticate/{username}",
      #       :params => {
      #           :username => Swagger.configuration.username,
      #           :password => Swagger.configuration.password
      #       }
      #   )
      #
      #   response_body = request.response.body
      #   Swagger.configuration.auth_token = response_body['token']
      # end
    end
  end

  class ServerError < StandardError
    attr_reader :status, :message

    def initialize(status, message)
      @status = status
      @message = message
    end
  end

  class ClientError < StandardError
    attr_reader :status, :message

    def initialize(status, message)
      @status = status
      @message = message
    end
  end
end