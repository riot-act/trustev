module Trustev
  class Profile

    SERVICE_URL = 'Decision'

    def initialize(case_id)
      raise Error.new('API v2.0 required.') if Trustev::api_version != '2.0'
      raise Error.new('Case ID is required') if case_id.nil?
      @case_id = case_id
    end

    def retrieve_decision
      Trustev.send_request "#{SERVICE_URL}/#{@case_id}", [], 'GET', true
    end
  end
end
