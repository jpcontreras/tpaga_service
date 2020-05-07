require 'rails_helper'

RSpec.describe TpagaService::CreditCardApi, type: :service do
  describe "Tpaga Credit Card API" do
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
		end

		it 'should create and add a new credit card' do
			response = TpagaService::CreditCardApi.add_credit_card(@credit_card_data)
      expect(response.class).to eq(Tpaga::CreditCard)
      expect(response.type).not_to eq(nil)
      expect(response.type).to eq("VISA")
      expect(response.expiration_year).to eq(@credit_card_data[:expiration_year].to_s)
    end

		it 'should return error if holder_name is not present ' do
			no_holder_name_data = @credit_card_data.except(:holder_name)
      expect { TpagaService::CreditCardApi.add_credit_card(no_holder_name_data) }.to raise_error(Packen::ApiError)
		end
		
		it 'should return error if credit card is not valid ' do
			not_valid_credit_card = @credit_card_data.merge({primary_number: '41111111'})
      expect { TpagaService::CreditCardApi.add_credit_card(not_valid_credit_card) }.to raise_error(Packen::ApiError)
		end
		
		it 'should return error if credit card is expired ' do
			expired_card = @credit_card_data.merge({expiration_year: (DateTime.now - 1.years).year})
      expect { TpagaService::CreditCardApi.add_credit_card(expired_card) }.to raise_error(Packen::ApiError)
			expired_card = @credit_card_data.merge({expiration_year: (DateTime.now - 1.months).year, expiration_month: ((DateTime.now - 1.months).strftime("%m"))})
			expect { TpagaService::CreditCardApi.add_credit_card(expired_card) }.to raise_error(Packen::ApiError)
    end
    
    it 'should return error if data format is wrong ' do
      @credit_card_data = nil
			expect{ TpagaService::CreditCardApi.add_credit_card(@credit_card_data) }.to raise_error Packen::ApiError
    end
    
		
		it 'should return error if credit card is not present ' do
			no_credit_number = @credit_card_data.except(:primary_number)
      expect { TpagaService::CreditCardApi.add_credit_card(no_credit_number) }.to raise_error(Packen::ApiError)
		end

		it 'should delete credit card by id ' do
			response_create = TpagaService::CreditCardApi.add_credit_card(@credit_card_data)
			response = TpagaService::CreditCardApi.delete_credit_card_by_id(@customer.id, response_create.id)
		end

    it 'should return error if try to delete credit card using worng id ' do
			response_create = TpagaService::CreditCardApi.add_credit_card(@credit_card_data)
			expect { TpagaService::CreditCardApi.delete_credit_card_by_id("asd", response_create.id) }.to raise_error(Packen::ApiError)
			expect { TpagaService::CreditCardApi.delete_credit_card_by_id(@customer.id, '123asd') }.to raise_error(Packen::ApiError)
		end

  end
end

