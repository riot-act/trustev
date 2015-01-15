require_relative 'test_helper'

describe Trustev::CustomerAddress do
  before do
    @trustev_case = build_case
    @case_id = @trustev_case.create[:Id]
    @customer_address = build_customer_address case_id: @case_id
  end

  describe 'when creating a customer address' do
    it 'must return a valid response' do
      create_case_attribute @customer_address
    end
  end

  describe 'when updating a customer address' do
    it 'must return a valid response' do
      update_case_attribute @customer_address, self.method(:build_customer_address), @case_id, { first_name: Faker::Name.first_name }
    end
  end

  describe 'when retrieving a customer address' do
    it 'must return a valid response' do
      customer_address = @trustev_case.retrieve[:Customer][:Addresses][0]
      to_retrieve = Trustev::CustomerAddress.new(case_id: @case_id, id: customer_address[:Id])
      to_retrieve.retrieve[:Id].wont_be_nil
    end
  end

  describe 'when retrieving all customer addresses' do
    it 'must return a valid response' do
      retrieve_all_case_attribute Trustev::Social, @case_id
    end
  end
end
