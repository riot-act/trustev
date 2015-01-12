module Trustev
  class Address < CaseAttribute

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

    def retrieve_all
      Trustev.send_request url, {}, 'GET'
    end

    def update
      raise Error.new('ID is required') if @opts[:id].nil?
      Trustev.send_request url(true), build, 'PUT'
    end

    private

    def build
      {
        Id: @opts[:id],
        FirstName: @opts[:first_name],
        LastName: @opts[:last_name],
        Address1: @opts[:address1],
        Address2: @opts[:address2],
        Address3: @opts[:address3],
        City: @opts[:city],
        State: @opts[:state],
        PostalCode: @opts[:postal_code],
        Type: @opts[:type],
        CountryCode: @opts[:country_code],
        Timestamp: @opts[:timestamp],
        IsDefault: @opts[:is_Default]
      }
    end
  end
end
