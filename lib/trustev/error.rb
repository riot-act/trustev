module Trustev
  class Error < StandardError
    attr_reader :message
    attr_reader :http_status

    def initialize(message=nil, http_status=nil, trustev_message=nil)
      @message = "#{message} #{trustev_message}"
      @http_status = http_status

      super(message)
    end

    def to_s
      status_string = @http_status.nil? ? '' : "(Status #{@http_status}) "
      "#{status_string}#{@message}"
    end
  end
end