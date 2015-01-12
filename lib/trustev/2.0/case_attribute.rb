module Trustev
  class CaseAttribute
    def url(with_identifier=false)
      url = "case/#{@case_id}/#{SERVICE_URL}"
      url = "#{url}/#{@opts[:id]}" if with_identifier
      url
    end
  end
end
