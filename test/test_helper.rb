require_relative '../lib/trustev'
require 'minitest/autorun'
require 'securerandom'

Trustev.username = 'FancyTees'
Trustev.password = '58dcca6b98a24e5a80b2a3682190da1a'
Trustev.shared_secret = '48357fbb820c407f855d72893d3f47ed'
Trustev.private_key = '65950d41f8d3ea86dc25aaf893ba15db'
Trustev.api_version = '1.2'

def build_transaction
  {
    social_network: {
      type: Trustev::SOCIAL_NETWORK_TYPES[:facebook],
      id: '780218520'
    },
    transaction_data: {
      currency_code: 'EUR',
      total_delivery: 10.0,
      total_before_tax: 40,
      total_discount: 10,
      total_tax: 10,
      total_transaction_value: 50.00,
      timestamp: 1391449224000,
      address: [
        {
          type: Trustev::ADDRESS_TYPES[:standard],
          first_name: 'Joe',
          last_name: 'Bloggs',
          address_1: '2011',
          address_2: 'Imaginary Way',
          address_3: '',
          city: 'Anycity',
          state: 'AnyState',
          postal_code: '123456',
          country_code: 'US'
        }
      ],
      item: [
        {
          name: 'T-Shirt',
          url: 'T-shirts.com',
          image_url: 'T-shirts.com/Trustev-T-Shirt',
          quantity: 1,
          total_before_tax: 40.0,
          total_discount: 0.0,
          total_tax: 10,
          total_item_value: 50.0
        }
      ]
    },
    customer: {
      first_name: 'John',
      last_name: 'Doe',
      phone_number: '00353861658789',
      date_of_birth: 1403256280325,
      email: [
        {
          is_default: true,
          email_address: "jondoe@mail.com"
        }
      ],
      address: [
        {
          type: Trustev::ADDRESS_TYPES[:standard],
          first_name: 'Joe',
          last_name: 'Bloggs',
          address_1: '2011',
          address_2: 'Imaginary Way',
          address_3: '',
          city: 'Anycity',
          state: 'AnyState',
          postal_code: '123456',
          country_code: 'US',
          is_default: true
        }
      ]
    },
    session_id: '4cec59b2-37f9-461e-9abc-861267e1a4d7'
  }
end
