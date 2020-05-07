require 'tpaga_service/api/version'

# APIs

require 'tpaga_service/api/charge_api'
require 'tpaga_service/api/credit_card_api'
require 'tpaga_service/api/customer_api'
require 'tpaga_service/api/refund_api'


module TpagaService
  # Initialize the default configuration
  Swagger.configuration ||= Swagger::Configuration.new
end
