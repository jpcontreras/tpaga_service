require 'rails_helper'

RSpec.describe TpagaService::RefundApi, type: :service do
  describe "Tpaga Refund API" do

    before(:each) do
      @customer = TpagaService::CustomerApi.create_customer({
        firstName: 'foo',
        lastName: 'bar',
        email: 'foo@bar.com',
        phone: '0000000000'
      })
      @credit_card_data = {
          customer_id: @customer.id, primary_number: '4111111111111111',
          expiration_month: ((DateTime.now + 1.months).strftime("%m")), expiration_year: (DateTime.now + 1.years).year,
          billing_address: Tpaga::BillingAddress.new, holder_name: "#{@customer.first_name} #{@customer.last_name}",
          security_code: '789'
      }
      @payment_data = {
          # "creditCard"   => self.card_token,
          "customer"     => @customer,
          "amount"       => 1000,
          "currency"     => "COP",
          "installments" => 1,
          "taxAmount"    => 0,
          "orderId"      => 123,
          "thirdPartyId" => 456,
          "description"  => "Cobro servicio #{123} — #{456}"
      }
      @response_create_card = TpagaService::CreditCardApi.add_credit_card(@credit_card_data)
      payment_ = @payment_data.merge({creditCard: @response_create_card.id})
      @response_charge_data = TpagaService::ChargeApi.add_credit_card_charge(payment_)
    end

    it 'should create a new right refund' do
      response = TpagaService::RefundApi.get_refund_credit_card_charge(@response_charge_data.id)
      expect(response.class).to eq(Tpaga::CreditCardCharge)
      expect(response.id).not_to eq(nil)
    end

    it 'should return error if customer api data is not right' do
      expect { TpagaService::RefundApi.get_refund_credit_card_charge("test_text") }.to raise_error(Packen::ApiError)
    end
  end
end

