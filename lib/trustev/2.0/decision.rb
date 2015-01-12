module Trustev
  class Decision

    SERVICE_URL = 'Decision'

    def initialize(case_id)
      raise Error.new('Case ID is required') if case_id.nil?
      @case_id = case_id
    end

    def retrieve_decision
      Trustev.send_request "#{SERVICE_URL}/#{@case_id}", [], 'GET'
    end
  end
end
