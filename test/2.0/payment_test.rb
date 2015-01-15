require_relative 'test_helper'

describe Trustev::Payment do
  before do
    trustev_case = build_case
    @case_id = trustev_case.create[:Id]
    @payment = build_payment case_id: @case_id
  end

  describe 'when creating a payment' do
    it 'must return a valid response' do
      create_case_attribute @payment
    end
  end

  describe 'when updating a payment' do
    it 'must return a valid response' do
      update_case_attribute @payment, self.method(:build_payment), @case_id, { bin_number: Faker::Number.number(6) }
    end
  end

  describe 'when retrieving a payment' do
    it 'must return a valid response' do
      retrieve_case_attribute @payment, Trustev::Payment, @case_id
    end
  end

  describe 'when retrieving all payments' do
    it 'must return a valid response' do
      retrieve_all_case_attribute Trustev::Payment, @case_id
    end
  end
end
