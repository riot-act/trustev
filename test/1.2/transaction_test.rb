require_relative 'test_helper'
require 'securerandom'

describe Trustev::Transaction do

  before do
    @transaction_number = SecureRandom.hex
    @transaction = Trustev::Transaction.new(@transaction_number)
  end

  describe 'when creating a transaction' do
    it 'must return a good response code' do
      @transaction.create(build_transaction).code.must_equal 200
    end
  end

  describe 'when updating a transaction' do
    it 'must return a good response code' do
      @transaction.create(build_transaction)
      @transaction.update(build_transaction).code.must_equal 200
    end
  end

  describe 'when updating the status of a transaction' do
    it 'must return a good response code' do
      @transaction.create(build_transaction)
      @transaction.set_status(3, 2, 'Transaction was refused due to a Trustev Score of 35').code.must_equal 200
    end
  end

  describe 'when setting a transaction\'s BIN' do
    it 'must return a good response code' do
      @transaction.create(build_transaction)
      @transaction.set_bin(411111).code.must_equal 200
    end
  end
end