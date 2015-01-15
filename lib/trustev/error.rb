module Trustev
  class Error < StandardError
    attr_reader :message
    attr_reader :http_status

    def initialize(message=nil, http_status=nil, trustev_message=nil)
      status_string = http_status.nil? ? '' : "(#{http_status}) "
      trustev_message = "- #{trustev_message}" unless trustev_message.nil?
      @message = "#{status_string}#{message} #{trustev_message}"

      super(message)
    end
  end
end
