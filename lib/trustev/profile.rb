module Trustev
  class Profile

    SERVICE_URL = 'ProfileService.svc/rest/Transaction'

    SOURCES = [0, 1, 2, 3, 4, 5, 6, 7, 8]

    PARAMETERS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]

    def initialize(transaction_number)
      raise Error.new('Transaction Number is required') if transaction_number.nil?
      @transaction_number = transaction_number
    end

    def retrieve_scores
      Trustev.send_request "#{SERVICE_URL}/#{@transaction_number}", [], 'GET', true
    end

    def get_overall_score
      get_score(7, 0)
    end

    def get_score(source_id, parameter_id)
      raise Error.new('Invalid Source') if SOURCES.index(source_id).nil?
      raise Error.new('Invalid Parameter') if PARAMETERS.index(parameter_id).nil?
      response = retrieve_scores
      response[:Profile][:Sources].each do | source |
        if source[:Source] == source_id
          source[:Scores].each { | score | return score[:Score] if score[:Parameter] == parameter_id }
        end
      end
    end
  end
end