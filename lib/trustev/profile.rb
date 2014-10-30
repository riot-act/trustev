module Trustev
  class Profile

    SERVICE_URL = 'ProfileService.svc/rest/Transaction'

    def self.retrieve(transaction_number)
      raise Error.new('Transaction Number is required') if transaction_number.nil?
      Trustev.send_request "#{SERVICE_URL}/#{transaction_number}", [], 'GET', true
    end
  end
end