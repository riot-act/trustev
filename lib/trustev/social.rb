module Trustev
  class Social

    SERVICE_URL = 'SocialService.svc/rest/Profile'
    SOCIAL_NETWORK_TYPES = [0, 1, 2, 3]

    def self.create(social_networks=[])
      validate(social_networks)
      Trustev.send_request SERVICE_URL, build(social_networks), 'POST'
    end

    def self.update(social_network)
      validate([social_network])
      Trustev.send_request "#{SERVICE_URL}/#{social_network[:type]}/#{social_network[:id]}", build([social_network]), 'PUT'
    end

    def self.delete(social_network_type, social_network_id)
      Trustev.send_request "#{SERVICE_URL}/#{social_network_type}/#{social_network_id}", {}, 'DELETE'
    end

    private

    def self.validate(social_networks)
      raise Error.new('Social Network array is empty') if social_networks.size == 0
      social_networks.each do | social_network |
        raise Error.new('Invalid Social Network Type') if SOCIAL_NETWORK_TYPES.index(social_network[:type]).nil?
        raise Error.new('Social Network Type is required') if social_network[:type].nil?
        raise Error.new('Social Network ID is required') if social_network[:id].nil?
        raise Error.new('Short Term Access Token is required') if social_network[:short_term_token].nil?
        raise Error.new('Long Term Access Token is required') if social_network[:long_term_token].nil?
        raise Error.new('Short Term Access Token Expiry is required') if social_network[:short_term_expiry].nil?
        raise Error.new('Long Term Access Token Expiry is required') if social_network[:long_term_expiry].nil?
        raise Error.new('Social Network Secret is required') if social_network[:secret].nil?
      end
    end

    def self.build(social_networks)
      social_network_data = {
        SocialNetworks: []
      }

      social_networks.each do | social_network |
        social_network_data[:SocialNetworks].push({
          Type: social_network[:type],
          Id: social_network[:id],
          ShortTermAccessToken: social_network[:short_term_token],
          LongTermAccessToken: social_network[:long_term_token],
          ShortTermAccessTokenExpiry: "\/Date(#{social_network[:short_term_expiry]})\/",
          LongTermAccessTokenExpiry: "\/Date(#{social_network[:long_term_expiry]})\/",
          Secret: social_network[:secret]
        })
      end

      social_network_data
    end
  end
end