module Trustev
  class Payment < CaseAttribute

    SERVICE_URL = 'payment'

    def create
      Trustev.send_request url, build, 'POST'
    end

    def retrieve
      raise Error.new('ID is required') if @opts[:id].nil?
      Trustev.send_request url(true), {}, 'GET'
    end

    def retrieve_all
      Trustev.send_request url, {}, 'GET'
    end

    def update
      raise Error.new('ID is required') if @opts[:id].nil?
      Trustev.send_request url(true), build, 'PUT'
    end

    def build
      payment = {
        PaymentType: @opts[:payment_type],
        BINNumber: @opts[:bin_number]
      }
      payment[:id] = @opts[:id] unless @opts[:id].nil?
      payment
    end
  end
end
