module Trustev
  class Social < CaseAttribute

    SERVICE_URL = 'customer/socialaccount'

    def create
      Trustev.send_request url, build, 'POST'
    end

    def retrieve
      raise Error.new('ID is required') if @opts[:id].nil?
      Trustev.send_request url(true), {}, 'GET'
    end

    def retrieve_all
      Trustev.send_request url, {}, 'GET'
    end

    def update
      raise Error.new('ID is required') if @opts[:id].nil?
      Trustev.send_request url(true), build, 'PUT'
    end

    def build
      social = {
        SocialId: @opts[:social_id],
        ShortTermAccessToken: @opts[:short_term_access_token],
        LongTermAccessToken: @opts[:long_term_access_token],
        ShortTermAccessTokenExpiry: @opts[:short_term_access_token_expiry],
        LongTermAccessTokenExpiry: @opts[:long_term_access_token_expiry],
        Secret: @opts[:secret],
        Timestamp: @opts[:timestamp]
      }
      social[:id] = @opts[:id] unless @opts[:id].nil?
      social
    end
  end
end
