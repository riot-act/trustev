module Trustev
  class Status < CaseAttribute

    SERVICE_URL = 'status'

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

    def build
      status = {
        Status: @opts[:status],
        Comment: @opts[:comment],
        Timestamp: @opts[:timestamp]
      }
      status[:id] = @opts[:id] unless @opts[:id].nil?
      status
    end
  end
end
