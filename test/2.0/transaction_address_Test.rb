require_relative 'test_helper'

describe Trustev::TransactionAddress do
  before do
    trustev_case = build_case
    @case_id = trustev_case.create[:Id]
    @transaction_address = build_customer_address case_id: @case_id
  end

  describe 'when creating a transaction address' do
    it 'must return a valid response' do
      create_case_attribute @transaction_address
    end
  end

  describe 'when updating a transaction address' do
    it 'must return a valid response' do
      update_case_attribute @transaction_address, self.method(:build_transaction_address), @case_id, { first_name: Faker::Name.first_name }
    end
  end

  describe 'when retrieving a transaction address' do
    it 'must return a valid response' do
      retrieve_case_attribute @transaction_address, Trustev::TransactionAddress, @case_id
    end
  end

  describe 'when retrieving all transaction addresses' do
    it 'must return a valid response' do
      retrieve_all_case_attribute Trustev::TransactionAddress, @case_id
    end
  end
end
