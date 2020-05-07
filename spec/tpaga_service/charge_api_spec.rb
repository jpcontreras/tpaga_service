require 'rails_helper'

RSpec.describe TpagaService::ChargeApi, type: :service do
  describe "Tpaga Charge API" do

    before(:each) do
      @customer = TpagaService::CustomerApi.create_customer({
        firstName: 'foo',
        lastName: 'bar',
        email: 'foo@bar.com',
        phone: '0000000000'
      })
      @customer2 = TpagaService::CustomerApi.create_customer({
        firstName: 'foo2',
        lastName: 'bar2',
        email: 'foo2@bar.com',
        phone: '0000000000'
      })
      @credit_card_data = {
          customer_id: @customer.id,
          primary_number: '4111111111111111',
          expiration_month: ((DateTime.now + 1.months).strftime("%m")),
          expiration_year: (DateTime.now + 1.years).year,
          billing_address: Tpaga::BillingAddress.new,
          holder_name: "#{@customer.first_name} #{@customer.last_name}",
          security_code: '789'
      }
      @credit_card_data2 = {
        customer_id: @customer.id,
        primary_number: '4111111111111111',
        expiration_month: ((DateTime.now + 1.months).strftime("%m")),
        expiration_year: (DateTime.now + 1.years).year,
        billing_address: Tpaga::BillingAddress.new,
        holder_name: "#{@customer.first_name} #{@customer.last_name}",
        security_code: '789'
    }
      @payment_data = {
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
      @response_create_card2 = TpagaService::CreditCardApi.add_credit_card(@credit_card_data2)
    end

    it 'should charge payment to one created card' do
      payment_ = @payment_data.merge({creditCard: @response_create_card.id})
      @response = TpagaService::ChargeApi.add_credit_card_charge(payment_)
      expect(@response.class).to eq(Tpaga::CreditCardCharge)
      expect(@response.id).not_to eq(nil)
      TpagaService::RefundApi.get_refund_credit_card_charge(@response.id)
    end

    it 'should charge payment to one created card with fake id' do
      payment_ = @payment_data.merge({creditCard: "asdasdasdasdasd"}).except(:amount)
      expect { TpagaService::ChargeApi.add_credit_card_charge(payment_) }.to raise_error(Packen::ApiError)
    end
  end
end

