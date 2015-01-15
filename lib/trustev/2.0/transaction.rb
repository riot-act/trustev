module Trustev
  class Transaction < CaseAttribute

    SERVICE_URL = 'transaction'

    def create
      Trustev.send_request url, build, 'POST'
    end

    def retrieve
      Trustev.send_request url, {}, 'GET'
    end

    def update
      Trustev.send_request url, build, 'PUT'
    end

    def build
      transaction = {
        TotalTransactionValue: @opts[:total_transaction_value],
        Currency: @opts[:currency_code],
        timestamp: @opts[:timestamp],
        addresses: @opts[:addresses],
        items: @opts[:items]
      }
      transaction[:id] = @opts[:id] unless @opts[:id].nil?
      transaction
    end
  end
end
