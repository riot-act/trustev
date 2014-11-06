require_relative 'test_helper'
require 'securerandom'

describe Trustev::Profile do

  before do
    @transaction_number = SecureRandom.hex
    transaction = Trustev::Transaction.new(@transaction_number)
    transaction.create(build_transaction)
    @profile = Trustev::Profile.new(@transaction_number )
  end

  describe 'when retrieving all scores' do
    it 'must return a json object containing score data' do
      score_data = @profile.retrieve_scores
      score_data[:Code].must_equal 200
      score_data[:Message].must_equal 'Success'
      score_data[:Timestamp].must_match /\/Date\(.*\)\//
      score_data[:Profile].must_be_instance_of Hash
      score_data[:Profile][:Sources].must_be_instance_of Array
      score_data[:Profile][:Sources][0].must_be_instance_of Hash
      score_data[:Profile][:Sources][0][:Source].must_equal 7
      score_data[:Profile][:Sources][0][:Scores].must_be_instance_of Array
      score_data[:Profile][:Sources][0][:Scores][0][:Confidence].must_be_instance_of Fixnum
      score_data[:Profile][:Sources][0][:Scores][0][:Parameter].must_be_instance_of Fixnum
      score_data[:Profile][:Sources][0][:Scores][0][:Score].must_be_instance_of Float
    end
  end

  describe 'when retrieving overall score' do
    it 'must just return the overall score' do
      @profile.get_overall_score.must_be_instance_of Float
    end
  end

  describe 'when retrieving a specific score' do
    it 'must return that specific score' do
      @profile.retrieve_scores[:Profile][:Sources].each do | source |
        if source[:Source] == 7
          source[:Scores].each { | score | score[:Score].must_equal @profile.get_score(7, 0) if score[:Parameter] == 0 }
        end
      end
    end
  end
end