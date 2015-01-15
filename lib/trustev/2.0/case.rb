require 'digest'
require 'open-uri'

module Trustev
  class Case

    SERVICE_URL = 'Case'

    def initialize(case_id=nil, opts={})
      @case_id = case_id
      @opts = opts
    end

    def create
      response = Trustev.send_request SERVICE_URL, build, 'POST'
      @case_id = response[:Id]
      response
    end

    def update
      raise Error.new('Case ID is required.') if @case_id.nil?
      Trustev.send_request "#{SERVICE_URL}/#{URI::encode @case_id}", build, 'PUT'
    end

    def retrieve
      raise Error.new('Case ID is required.') if @case_id.nil?
      Trustev.send_request "#{SERVICE_URL}/#{URI::encode @case_id}", [], 'GET'
    end

    def build
      keys = { session_id: :SessionID,
               case_number: :CaseNumber,
               transaction: :Transaction,
               customer: :Customer,
               statuses: :Statuses,
               payments: :Payments,
               timestamp: :Timestamp }
      trustev_case = {}
      @opts.each do |key, value|
        trustev_case[keys[key]] = value
      end
      trustev_case
    end
  end
end
