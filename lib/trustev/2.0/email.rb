module Trustev
  class Email

    SERVICE_URL = 'customer/email'

    def initialize(case_id, id, email, is_default=false)
      raise Error.new('Case ID is required') if case_id.nil?

      @case_id = case_id
      @id = id
      @email = email
      @is_default = is_default
    end

    def create
      raise Error.new('Email is required') if email.nil?
      Trustev.send_request url, build, 'POST'
    end

    def retrieve
      raise Error.new('ID is required') if id.nil?
      Trustev.send_request url(true), {}, 'GET'
    end

    def retrieve_all
      Trustev.send_request url, {}, 'GET'
    end

    def update
      raise Error.new('Email is required') if email.nil?
      Trustev.send_request url(true), {}, 'PUT'
    end

    private

    def url(with_identifier=false)
      url = "case/#{@case_id}/#{SERVICE_URL}"
      url = "#{url}/#{@id}" if with_identifier
      url
    end

    def build
      {
        Id: @id,
        EmailAddress: @email,
        IsDefault: @is_default
      }
    end
  end
end
