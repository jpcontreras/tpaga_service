module TpagaService
  module ChargeApi
    extend self
    # ===== Parameters:
    # *+data+ : Hash -
    # {
    #   "creditCard": "string",
    #   "amount": 0,
    #   "currency": "string",
    #   "installments": 0,
    #   "orderId": "string",
    #   "taxAmount": 0, (optional)
    #   "iacAmount": 0, (optional)
    #   "tipAmount": 0, (optional)
    #   "description": "string",
    #   "thirdPartyId": "string",  (optional)
    #   "childMerchantId": "string" (optional)
    # }
    # ===== Return:
    # +Hash+ - {
    #   "id": "string",
    #   "amount": 0,
    #   "taxAmount": 0,
    #   "childMerchantId": "string",
    #   "currency": "string",
    #   "creditCard": "string",
    #   "installments": 0,
    #   "orderId": "string",
    #   "iacAmount": 0,
    #   "tipAmount": 0,
    #   "description": "string",
    #   "dateCreated": "2020-04-30T00:51:06.192Z",
    #   "thirdPartyId": "string",
    #   "paid": true,
    #   "customer": "string",
    #   "paymentTransaction": "string",
    #   "errorCode": "string",
    #   "errorMessage": "string",
    #   "reteRentaAmount": "string",
    #   "reteIcaAmount": "string",
    #   "reteIvaAmount": "string",
    #   "tpagaFeeAmount": "string",
    #   "transactionInfo": {
    #     "authorizationCode": "string",
    #     "status": "created"
    #   }
    # }
    def add_credit_card_charge(data)
      host = Swagger.configuration.host
      api_key = Swagger.configuration.private_api_key

      conn = Faraday.new
      resp = conn.post do |req|
        req.url "https://#{host}/api/charge/credit_card"
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = 'Basic ' + ["#{api_key}:"].pack('m').delete("\r\n")
        req.body = data.to_json
      end
      body = JSON.parse(resp.body)
      Swagger::Response.new(resp.status, body)
      return body
    end
  end
end