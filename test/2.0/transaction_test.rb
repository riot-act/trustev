require_relative 'test_helper'

describe Trustev::Transaction do
  describe 'when creating a transaction' do
    it 'must return a valid response' do
      trustev_case = build_case nil, SecureRandom.hex, { transaction: nil }
      case_id = trustev_case.create[:Id]
      transaction = build_transaction case_id: case_id
      transaction.create[:Id].wont_be_nil
    end
  end

  describe 'when updating a transaction' do
    it 'must return a valid response' do
      trustev_case = build_case.create
      case_id = trustev_case[:Id]
      transaction = build_transaction case_id: case_id, currency_code: 'EUR'
      transaction.update[:Id].wont_be_nil
    end
  end

  describe 'when retrieving a transaction' do
    it 'must return a valid response' do
      trustev_case = build_case.create
      case_id = trustev_case[:Id]
      transaction_id = trustev_case[:Transaction][:Id]
      transaction = Trustev::Transaction.new id: transaction_id, case_id: case_id
      transaction.retrieve[:Id].wont_be_nil
    end
  end
end
