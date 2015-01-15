require_relative 'test_helper'

describe Trustev::Customer do
  describe 'when creating a customer' do
    it 'must return a valid response' do
      trustev_case = build_case nil, SecureRandom.hex, { customer: nil }
      case_id = trustev_case.create[:Id]
      customer = build_customer case_id: case_id
      customer.create[:Id].wont_be_nil
    end
  end

  describe 'when updating a customer' do
    it 'must return a valid response' do
      trustev_case = build_case
      case_id = trustev_case.create[:Id]
      customer = build_customer case_id: case_id, first_name: Faker::Name.first_name
      customer.update[:Id].wont_be_nil
    end
  end

  describe 'when retrieving a customer' do
    it 'must return a valid response' do
      trustev_case = build_case.create
      case_id = trustev_case[:Id]
      customer_id = trustev_case[:Customer][:Id]
      customer = Trustev::Customer.new id: customer_id, case_id: case_id
      customer.retrieve[:Id].wont_be_nil
    end
  end
end
