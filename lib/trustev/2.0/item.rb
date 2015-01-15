module Trustev
  class Item < CaseAttribute

    SERVICE_URL = 'transaction/item'

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
      item = {
        Name: @opts[:name],
        Quantity: @opts[:quantity],
        ItemValue: @opts[:item_value]
      }
      item[:id] = @opts[:id] unless @opts[:id].nil?
      item
    end
  end
end
