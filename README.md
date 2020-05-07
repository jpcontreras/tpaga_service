TPaga Service
===

TPaga Service gem provides the functionality to call the multiple services of the TPaga platform.

Installation
---

To install as a gem in your environment type in your console:

```sh
gem install tpaga_service
```

If you want to use in your rails application, add to your Gemfile:

```ruby
gem 'tpaga_service'
```

And run from your application directory:

```sh
bundle install
```

Configuration
---

If you are going to run tpaga in a rails environment add to the environment file (ex: `environments/development.rb`) the following lines:

```ruby
  config.schema           = 'https'
  config.host             = 'sandbox.tpaga.co'
  config.base_path        = '/api'
  config.private_api_key  = 'd13fr8n7vhvkuch3lq2ds5qhjnd2pddw2'
  config.public_api_key   = 'e8tbtu6bdi1jts34h2ktdipschq9heq0a'
```

using the respective api key for your TPaga user account.

Next add the the file `tpaga_service.rb` to the rails initializers (ex: `initializers/tpaga_service.rb`) with he following lines:

```ruby
require 'tpaga_service'

TpagaService::Swagger.configure do |config|
  config.scheme          = Rails.application.config.tpaga_schema
  config.host            = Rails.application.config.tpaga_host
  config.base_path       = Rails.application.config.tpaga_base_path
  config.private_api_key = Rails.application.config.tpaga_private_api_key
  config.public_api_key  = Rails.application.config.tpaga_public_api_key
  config.inject_format   = false
end
```

if you are not using rails, just simply initialize the service with the lines in the tpaga initializer before you call any service of the api.

Managing customers
---

You can create a customer:

```ruby
# if outside from rails
require 'tpaga_service'

# creating a tpaga_service customer object
customer = {
  firstName: 'foo',
  lastName:  'bar',
  email:     'foo@bar.com',
  phone:     '0000000000',
  gender:    'M'
}

# call of the api to create the customer in the TPaga account
customer = TpagaService::CustomerApi.create_customer customer
customer.id # The unique identifier of the customer in the TPaga account
# if the request cannot be completed, raise a generic error
```

Get a customer by it's id:

```ruby
customer = TpagaService::CustomerApi.get_customer_by_id 'id'
# returns a TpagaService::Customer object, raise error if not
```

Delete a customer by it's id:

```ruby
response = TpagaService::CustomerApi.delete_customer_by_id 'customer_id'
# return nil if success, raise an error if not
```
Managing credit cards
---

You can add a credit card to existing customers:

```ruby
# build the credit card object to create
credit_card_create = {
  primaryAccountNumber: '4111111111111111',
  expirationMonth:      '08',
  expirationYear:       '2023',
  cardVerificationCode: '789',
  cardHolderName:       'Jon Snow'
}

credit_card = TpagaService::CreditCardApi.add_credit_card credit_card_create, 'customer_id'
# returns a TpagaService::CreditCard object, raise error if not
```

you can get the credit card of customers (NOT AVAILABLE):

```ruby
credit_card = TpagaService::CreditCardApi.get_credit_card_by_id 'customer_id', 'credit_card_id'
# return a TpagaService::CreditCard object, raise error if not
```

You can delete the credit card of customers:

```ruby
TpagaService::CreditCardApi.delete_credit_card_by_id 'customer_id', 'credit_card_id'
# return nil if success, raise error if not
```

You can charge a credit card:

```ruby
# build the charge object
charge = {
  amount:       10000,
  taxAmount:    10000 * 0.1,
  currency:     'COP',
  orderId:      'Your identifier for the order',
  installments: 1,
  description:  'A new leash for ghost',
  creditCard:   'credit_card_id'
}

charge = TpagaService::CreditCardApi.add_credit_card_charge charge
# return a TpagaService::CreditCardCharge object, raise error if not
```

Retrieve a charge by it's id  (NOT AVAILABLE):

```ruby
charge = TpagaService::CreditCardApi.get_credit_card_charge_by_id 'charge_id'
# return a TpagaService::CreditCardCharge object, raise error if not
``` 