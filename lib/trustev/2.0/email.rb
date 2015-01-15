module Trustev
  class Email < CaseAttribute

    SERVICE_URL = 'customer/email'

    def create
      raise Error.new('Email is required') if @opts[:email].nil?
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
      raise Error.new('Email is required') if @opts[:email].nil?
      raise Error.new('ID is required') if @opts[:id].nil?
      Trustev.send_request url(true), build, 'PUT'
    end

    def build
      email = {
        EmailAddress: @opts[:email],
        IsDefault: @opts[:is_default]
      }
      email[:id] = @opts[:id] unless @opts[:id].nil?
      email
    end
  end
end
