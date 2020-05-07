module TpagaService
  module CustomerApi
    extend self

    # ===== Parameters:
    # *+data+ Hash - { firstName: '', lastName: '', email: '', phone: '' }
    # ===== Return:
    # +Hash+ - {\"id\"=>\"cus-ljcvjfcc4mwzh4j2qmv40gqqu2x2\", \"firstName\"=>\"Sta. Elisa Melgar Arteaga\", \"lastName\"=>\"Sta. Elisa Melgar Arteaga\", \"gender\"=>nil, \"email\"=>\"luciokling@wintheiser.org\", \"phone\"=>\"9521559\", \"legalIdNumber\"=>nil, \"merchantCustomerId\"=>nil}
    def create_customer(data)
      host = Rails.application.credentials[Rails.env.to_sym][:tpaga_api_host]
      api_key = Rails.application.credentials[Rails.env.to_sym][:tpaga_private_api_key]

      conn = Faraday.new
      resp = conn.post do |req|
        req.url "https://#{host}/api/customer"
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = 'Basic ' + ["#{api_key}:"].pack('m').delete("\r\n")
        req.body = data.to_json
      end
      body = JSON.parse(resp.body)
      TpagaService::validate_status_error(resp.status, body)
      return body
    rescue Packen::ApiError => e
      raise e
    end

    # ===== Parameters:
    # *+customer_id+ :  String
    # ===== Return:
    # +Hash+ - {
    #   "id": "string",
    #   "firstName": "string",
    #   "lastName": "string",
    #   "email": "string",
    #   "gender": "M",
    #   "phone": "string",
    #   "legalIdNumber": "string",
    #   "merchantCustomerId": "string",
    #   "address": {
    #     "addressLine1": "string",
    #     "addressLine2": "string",
    #     "postalCode": "string",
    #     "city": {
    #       "name": "Bogotá",
    #       "state": "DC",
    #       "country": "CO"
    #     }
    #   }
    # }
    def get_customer_by_id(customer_id)
      host = Rails.application.credentials[Rails.env.to_sym][:tpaga_api_host]
      api_key = Rails.application.credentials[Rails.env.to_sym][:tpaga_private_api_key]

      conn = Faraday.new
      resp = conn.get do |req|
        req.url "https://#{host}/api/customer/#{customer_id}"
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = 'Basic ' + ["#{api_key}:"].pack('m').delete("\r\n")
      end
      body = JSON.parse(resp.body)
      TpagaService::validate_status_error(resp.status, body)
      return body
    rescue Packen::ApiError => e
      raise e
    end

    # ===== Parameters:
    # *+customer_id+ :  String
    def delete_customer_by_id(customer_id)
      host = Rails.application.credentials[Rails.env.to_sym][:tpaga_api_host]
      api_key = Rails.application.credentials[Rails.env.to_sym][:tpaga_private_api_key]

      conn = Faraday.new
      resp = conn.delete do |req|
        req.url "https://#{host}/api/customer/#{customer_id}"
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = 'Basic ' + ["#{api_key}:"].pack('m').delete("\r\n")
      end
      body = JSON.parse(resp.body)
      TpagaService::validate_status_error(resp.status, body)
      return body
    rescue Packen::ApiError => e
      raise e
    end
  end
end