require 'open-uri'

module Trustev
  class Decision

    SERVICE_URL = 'Decision'

    def initialize(case_id)
      raise Error.new('Case ID is required') if case_id.nil?
      @case_id = case_id
    end

    def retrieve
      Trustev.send_request "#{SERVICE_URL}/#{URI::encode @case_id}", [], 'GET'
    end
  end
end
