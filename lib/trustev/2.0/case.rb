require 'digest'

module Trustev
  class Case

    SERVICE_URL = 'Case'

    def initialize(case_id=nil, opts)#transaction, case_number, session_id, customer, statuses, payments, timestamp=Trustev::Timestamp.new)
      raise Error.new('Transaction is required.') if opts[:transaction].nil?
      raise Error.new('Case Number is required.') if opts[:case_number].nil?
      raise Error.new('Session ID is required.') if opts[:session_id].nil?
      raise Error.new('Customer is required.') if opts[:customer].nil?
      raise Error.new('Statuses is required.') if opts[:statuses].nil?
      raise Error.new('Payments is required.') if opts[:payments].nil?
      raise Error.new('Invalid timestamp.') unless opts[:timestamp].instance_of?(Trustev::Timestamp)
      @case_id = case_id
      @opts = opts
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
        SessionId: @opts[:session_id],
        CaseNumber: @opts[:case_number],
        Transaction: @opts[:transaction],
        Customer: @opts[:customer],
        Statuses: @opts[:statuses],
        Payments: @opts[:payments],
        Timestamp: @opts[:timestamp].to_s
      }
    end
  end
end
