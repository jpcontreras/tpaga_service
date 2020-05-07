module TpagaService
  extend self
    module RefundApi
    extend self
    def get_refund_credit_card_charge(transaction_id)
    #   @refund_req = Tpaga::CreditCardRefund.new(id: transaction_id)
    #   return Tpaga::RefundApi.refund_credit_card_charge(@refund_req)
    # rescue Tpaga::ClientError => e
    #   data = JSON.parse(e.message, object_class: OpenStruct)
    #   TpagaService.raise_errors(e) unless data.status == 404
    #   raise Packen::ApiError.new(data.status, data.status, I18n.translate("errors.tpaga_service.#{data.status}"), {source: e.class})
    end
  end
end