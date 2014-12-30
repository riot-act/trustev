module Trustev
  class Profile

    SERVICE_URL = 'ProfileService.svc/rest/Transaction'

    def initialize(transaction_number)
      raise Error.new('Transaction Number is required') if transaction_number.nil?
      @transaction_number = transaction_number
    end

    def retrieve_scores
      Trustev.send_request "#{SERVICE_URL}/#{@transaction_number}", [], 'GET', true
    end

    def get_overall_score
      get_score(Trustev::SCORE_SOURCES[:trustev], Trustev::SCORE_PARAMETERS[:overall])
    end

    def get_score(source_id, parameter_id)
      raise Error.new('Invalid Source') if Trustev::SCORE_SOURCES.key(source_id).nil?
      raise Error.new('Invalid Parameter') if Trustev::SCORE_PARAMETERS.key(parameter_id).nil?
      response = retrieve_scores
      response[:Profile][:Sources].each do | source |
        if source[:Source] == source_id
          source[:Scores].each { | score | return score[:Score] if score[:Parameter] == parameter_id }
        end
      end
    end
  end
end
