module Trustev
  class Transaction < CaseAttribute

    SERVICE_URL = 'transaction'

    def initialize(case_id, opts)
      raise Error.new('Case ID is required') if case_id.nil?

      @case_id = case_id
      @opts = opts
    end

    def create
      Trustev.send_request url, build, 'POST'
    end

    def retrieve
      raise Error.new('ID is required') if @opts[:id].nil?
      Trustev.send_request url(true), {}, 'GET'
    end

    def update
      raise Error.new('ID is required') if @opts[:id].nil?
      Trustev.send_request url(true), build, 'PUT'
    end

    private

    def build
      {
        Id: @opts[:id],
        TotalTransactionValue: @opts[:total_transaction_value],
        Currency: @opts[:currency_code],
        timestamp: @opts[:timestamp],
        addresses: @opts[:addresses],
        items: @opts[:items]
      }
    end
  end
end
