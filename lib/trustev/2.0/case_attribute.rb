require 'open-uri'

module Trustev
  class CaseAttribute
    def initialize(opts)
      @opts = opts
    end

    def create(response)
      @opts[:id] = response[:Id]
      response
    end

    def url(with_identifier=false)
      raise Error.new('Case ID is required') if @opts[:case_id].nil?
      url = "case/#{URI::encode @opts[:case_id]}/#{self.class::SERVICE_URL}"
      if with_identifier
        raise Error.new('ID is required') if @opts[:id].nil?
        url = "#{url}/#{@opts[:id]}"
      end
      url
    end
  end
end
