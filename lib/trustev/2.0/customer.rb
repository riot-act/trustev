module Trustev
  class Customer < CaseAttribute

    SERVICE_URL = 'customer'

    def create
      Trustev.send_request url, build, 'POST'
    end

    def retrieve
      Trustev.send_request url(true), {}, 'GET'
    end

    def update
      Trustev.send_request url(true), build, 'PUT'
    end

    private

    def build
      {
        Id: @opts[:id],
        FirstName: @opts[:first_name],
        LastName: @opts[:last_name],
        Emails: @opts[:emails],
        PhoneNumber: @opts[:phone_number],
        DateOfBirth: @opts[:dob],
        Addresses: @opts[:addresses],
        SocialAccounts: @opts[:social_accounts]
      }
    end
  end
end
