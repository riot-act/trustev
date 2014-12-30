require 'digest'

module Trustev
  class Transaction

    SERVICE_URL = 'Case'

    def initialize(case_id=nil, transaction, case_number, session_id, customer, statuses, payments, timestamp=Trustev::Timestamp.new)
      raise Error.new('Transaction is required.') if transaction.nil?
      raise Error.new('Case Number is required.') if case_number.nil?
      raise Error.new('Session ID is required.') if session_id.nil?
      raise Error.new('Customer is required.') if customer.nil?
      raise Error.new('Statuses is required.') if statuses.nil?
      raise Error.new('Payments is required.') if payments.nil?
      raise Error.new('Invalid timestamp.') unless timestamp.instance_of?(Trustev::Timestamp)
      @case_id = case_id
      @transaction = transaction
      @case_number = case_number
      @session_id = session_id
      @customer = customer
      @statuses = statuses
      @payments = payments
      @timestamp = timestamp
    end

    def create
      Trustev.send_request SERVICE_URL, build, 'POST'
    end

    def update
      raise Error.new('Case ID is required.') if @case_id.nil?
      Trustev.send_request "#{SERVICE_URL}/#{@case_id}", build, 'PUT'
    end

    def retrieve
      raise Error.new('Case ID is required.') if @case_id.nil?
      Trustev.send_request "#{SERVICE_URL}/#{@case_id}", [], 'GET'
    end

    private

    def build
      {
        SessionId: @session_id,
        CaseNumber: @case_number,
        Transaction: @transaction,
        Customer: @customer,
        Statuses: @statuses,
        Payments: @payments,
        Timestamp: @timestamp
      }
    end
  end
end
