RSpec.describe TpagaService::CustomerApi, type: :service do
  describe "Tpaga Customer API" do
    it 'should create a new customer with right data' do
      response = TpagaService::CustomerApi.create_customer({
        firstName: 'foo',
        lastName: 'bar',
        email: 'foo@bar.com',
        phone: '0000000000'
      })
      expect(response.class).to eq(Tpaga::Customer)
      expect(response.id).to_not eq(nil)
      expect(response.first_name).to eq('foo')
    end

    it 'should return error if customer api data is not right' do
      expect { TpagaService::CustomerApi.create_customer({
         firstName: 'foo',
         lastName: 'bar',
         email: 'foo00000',
         phone: '0000000000'
      }) }.to raise_error(Packen::ApiError)
    end

    it 'Should return a customer found by id' do
      response = TpagaService::CustomerApi.create_customer({
        firstName: 'foo',
        lastName: 'bar',
        email: 'foo@bar.com',
        phone: '0000000000'
      })
      response = TpagaService::CustomerApi.get_customer_by_id(response.id)
      expect(response).to_not eq nil
    end

    it 'Should return a customer found by id' do
      expect{
        TpagaService::CustomerApi.get_customer_by_id(Faker::Alphanumeric.alphanumeric(32))
      }.to raise_error Packen::ApiError
    end

    it 'Should delete a customer found by id' do
      response = TpagaService::CustomerApi.create_customer({
        firstName: 'foo',
        lastName: 'bar',
        email: 'foo@bar.com',
        phone: '0000000000'
      })
      expect{ TpagaService::CustomerApi.delete_customer_by_id(response.id) }.to_not raise_error
    end

    it 'Should raise Packen::ApiError when try to delete customer not found' do
      response = TpagaService::CustomerApi.create_customer({
        firstName: 'foo',
        lastName: 'bar',
        email: 'foo@bar.com',
        phone: '0000000000'
      })
      expect{ TpagaService::CustomerApi.delete_customer_by_id(response.id) }.to_not raise_error
      expect{ TpagaService::CustomerApi.delete_customer_by_id(response.id) }.to raise_error Packen::ApiError
    end

  end
end

