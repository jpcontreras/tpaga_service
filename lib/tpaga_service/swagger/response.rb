module TpagaService
  module Swagger
    class Response

      # ===== Parameters:
      # *+code_response+ : Integer
      # *+message_error+ : Hash
      def initialize(code_response, body_response)
        case code_response
        when 500..510 then raise ServerError.new(code_response, body_response) #(ServerError, body_response)
        when 299..426 then raise ClientError.new(code_response, body_response) #(ClientError, body_response)
        end
      end

    end
  end
end
