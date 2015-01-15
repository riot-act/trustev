module Trustev
  class Customer < CaseAttribute

    SERVICE_URL = 'customer'

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
      customer = {
        FirstName: @opts[:first_name],
        LastName: @opts[:last_name],
        Emails: @opts[:emails],
        PhoneNumber: @opts[:phone_number],
        DateOfBirth: @opts[:dob],
        Addresses: @opts[:addresses],
        SocialAccounts: @opts[:social_accounts]
      }
      customer[:id] = @opts[:id] unless @opts[:id].nil?
      customer
    end
  end
end
