require_relative '../../lib/trustev'
require 'minitest/autorun'
require 'securerandom'
require 'faker'

Trustev.username = 'test-GiftcardZen'
Trustev.password = 'ecd24e0ae66848c4a9e1273b183a1b01'
Trustev.shared_secret = '9350ac0b77a94ab0aaf7928d71ec695d'
Trustev.private_key = '1ATGMYU8vYAFNBCrQgJZKSoVUpdBdsV7pTKWQAMTHMU='
Trustev.api_version = '2.0'

def build_case(case_id=nil, case_number=SecureRandom.hex, opts={})
  trustev_case = {
    session_id: '403667e1-90ff-4e07-a17b-055b7c68f3d5',
    case_number: case_number,
    timestamp: Trustev::Timestamp.new.to_s,
    transaction: build_transaction.build,
    customer: build_customer.build,
    statuses: [ build_status.build, build_status.build ],
    payments: [ build_payment.build, build_payment.build ],
  }
  trustev_case.merge! opts
  Trustev::Case.new(case_id, trustev_case)
end

def build_transaction_address(opts={})
  address = {
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    address1: Faker::Address.street_address,
    address2: Faker::Address.building_number,
    address3: Faker::Address.secondary_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    postal_code: Faker::Address.zip_code,
    type: Trustev::ADDRESS_TYPES.to_a.sample[1],
    country_code: 'US',
    timestamp: Trustev::Timestamp.new.to_s,
    is_default: %w(true false).sample
  }
  address.merge! opts
  Trustev::TransactionAddress.new(address)
end

def build_customer_address(opts={})
  address = {
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    address1: Faker::Address.street_address,
    address2: Faker::Address.building_number,
    address3: Faker::Address.secondary_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    postal_code: Faker::Address.zip_code,
    type: Trustev::ADDRESS_TYPES.to_a.sample[1],
    country_code: 'US',
    timestamp: Trustev::Timestamp.new.to_s,
    is_default: %w(true false).sample
  }
  address.merge! opts
  Trustev::CustomerAddress.new(address)
end

def build_item(opts={})
  item = {
    name: Faker::Commerce.product_name,
    quantity: Random.rand(1..10),
    item_value: Faker::Commerce.price
  }
  item.merge! opts
  Trustev::Item.new(item)
end

def build_transaction(opts={})
  transaction = {
    total_transaction_value: Faker::Commerce.price,
    currency_code: 'USD',
    timestamp: Trustev::Timestamp.new.to_s,
    addresses: [ build_transaction_address.build, build_transaction_address.build ],
    items: [ build_item.build, build_item.build ]
  }
  transaction.merge! opts
  Trustev::Transaction.new(transaction)

end

def build_customer(opts = {})
  customer = {
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    emails: [ build_email.build, build_email.build ],
    phone_number: Faker::PhoneNumber.phone_number,
    dob: Trustev::Timestamp.new.to_s,
    addresses: [ build_customer_address.build, build_customer_address.build ],
    social_accounts: [ build_social.build, build_social.build ]
  }
  customer.merge!(opts)
  Trustev::Customer.new(customer)
end

def build_email(opts = {})
  email = {
    email: Faker::Internet.email,
    is_default: %w(true false).sample
  }
  email.merge! opts
  Trustev::Email.new(email)
end

def build_social(opts={})
  social = {
    social_id: Faker::Number.number(5),
    short_term_access_token: SecureRandom.hex,
    long_term_access_token: SecureRandom.hex,
    short_term_access_token_expiry: Trustev::Timestamp.new.to_s,
    long_term_access_token_expiry: Trustev::Timestamp.new.to_s,
    secret: SecureRandom.hex,
    timestamp: Trustev::Timestamp.new.to_s
  }
  social.merge! opts
  Trustev::Social.new(social)
end

def build_status(opts={})
  status = {
    status: Trustev::STATUS_TYPES.to_a.sample[1],
    comment: Faker::Lorem.sentence,
    timestamp: Trustev::Timestamp.new.to_s
  }
  status.merge! opts
  Trustev::Status.new(status)
end

def build_payment(opts={})
  payment = {
    payment_type: Trustev::PAYMENT_TYPES.to_a.sample[1],
    bin_number: Faker::Number.number(6)
  }
  payment.merge! opts
  Trustev::Payment.new(payment)
end

def create_case_attribute(to_create)
  to_create.create[:Id].wont_be_nil
end

def update_case_attribute(to_update, builder, case_id, data_to_update)
  object_id = to_update.create[:Id]
  object = builder.call({ case_id: case_id, id: object_id }.merge!(data_to_update))
  object.update[:Id].wont_be_nil
end

def retrieve_case_attribute(to_retrieve, obj_to_retrieve, case_id)
  object_id = to_retrieve.create[:Id]
  object = obj_to_retrieve.new id: object_id, case_id: case_id
  object.retrieve[:Id].wont_be_nil
end

def retrieve_all_case_attribute(to_retrieve, case_id)
  objects = to_retrieve.new case_id: case_id
  objects = objects.retrieve_all
  objects.instance_of?(Array).must_equal true
end
