module TpagaService
  module CreditCardApi
    extend self

    def add_credit_card(data, customer_id=nil)
      customer_id = customer_id || data[:customer_id]
      return create_credit_card(get_created_credit_card(data), customer_id)
    rescue Packen::ApiError => e
      raise e
    end

    def delete_credit_card_by_id(customer_id, credit_card_id)
      host = Swagger.configuration.host
      api_key = Swagger.configuration.private_api_key

      conn = Faraday.new
      resp = conn.delete do |req|
        req.url "https://#{host}/api/customer/#{customer_id}"
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = 'Basic ' + ["#{api_key}:"].pack('m').delete("\r\n")
      end
      body = JSON.parse(resp.body)
      Swagger::Response.new(resp.status, body)
      return true
    end

    private

    def create_credit_card(credit_card_create, customer_id)
      host = Swagger.configuration.host
      api_key = Swagger.configuration.public_api_key

      conn = Faraday.new
      resp = conn.post do |req|
        req.url "https://#{host}/api/tokenize/credit_card"
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = 'Basic ' + ["#{api_key}:"].pack('m').delete("\r\n")
        req.body = credit_card_create.to_json
      end
      body = JSON.parse(resp.body)
      Swagger::Response.new(resp.status, body)
      if body["token"].present?
        unless body["used"]
          body = _add_credit_card(body["token"], customer_id)
        else
          raise Packen::ApiError.new(Packen::TpagaStatus::CREDIT_CARD_IN_USE, 401)
        end
      end
      return body
    end

    # ===== Parameters:
    # *+credit_card_token+ : String
    # *+customer_id+ : String
    # ===== Return
    # +Hash+ - {
    #     "id": "o8shhbmi9hanlcvk976lbq1p3ubavmmq",
    #     "bin": "411111",
    #     "type": "VISA",
    #     "expirationMonth": "12",
    #     "expirationYear": "2030",
    #     "lastFour": "1111",
    #     "customer": "i0ih8d8hcddv984kl7ou4iehrl7akroj",
    #     "cardHolderName": "Luis S.",
    #     "cardHolderLegalIdNumber": null,
    #     "cardHolderLegalIdType": "CC",
    #     "addressLine1": null,
    #     "addressLine2": null,
    #     "addressCity": null,
    #     "addressState": null,
    #     "addressPostalCode": null,
    #     "addressCountry": null,
    #     "fingerprint": "0e3fc45a1ce4414f442e0c50186db85b8dc53dda916909918eff3f7e811ad9ca",
    #     "validationCharge": {
    #         "successful": true,
    #         "errorCode": "00"
    #     }
    # }
    def _add_credit_card(credit_card_token, customer_id)
      host = Swagger.configuration.host
      api_key = Swagger.configuration.private_api_key

      conn = Faraday.new
      resp = conn.post do |req|
        req.url "https://#{host}/api/customer/#{customer_id}/credit_card_token"
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = 'Basic ' + ["#{api_key}:"].pack('m').delete("\r\n")
        req.body = {
          skipLegalIdCheck: false,
          token: credit_card_token
        }.to_json
      end
      body = JSON.parse(resp.body)
      Swagger::Response.new(resp.status, body)
      return body
    end

    # ===== Parameters:
    # *+data+ : Hash
    # ===== Return:
    # +Hash+
    def get_created_credit_card(data)
      {
        primaryAccountNumber: (data['primary_number'] || data[:primary_number]),
        expirationMonth: (data['expiration_month'] || data[:expiration_month]),
        expirationYear: (data['expiration_year'] || data[:expiration_year]),
        cardVerificationCode: (data['security_code'] || data[:security_code]),
        cardHolderName: (data['holder_name'] || data[:holder_name])
      }
    end
  end
end