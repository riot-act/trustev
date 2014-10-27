module Trustev
  class Profile
    def self.retrieve(transaction_number)
      raise Error.new('Transaction Number is required') if transaction_number.nil?
      send_request "ProfileService.svc/rest/Transaction/#{transaction_number}", [], 'GET', true
    end
  end
end