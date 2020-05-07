require 'tpaga_service/swagger'
require 'tpaga_service/swagger/configuration'
require 'tpaga_service/swagger/request'
require 'tpaga_service/swagger/response'

# APIs
require 'tpaga_service/api/version'
require 'tpaga_service/api/charge_api'
require 'tpaga_service/api/credit_card_api'
require 'tpaga_service/api/customer_api'
require 'tpaga_service/api/refund_api'


module TpagaService
  # Initialize the default configuration
  Swagger.configuration ||= Swagger::Configuration.new
end
