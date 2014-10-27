module Trustev
  class Social

    SOCIAL_NETWORK_TYPES = [0, 1, 2, 3]

    def self.create(social_networks=[])
      validate(social_networks)
      send_request 'SocialService.svc/rest/Profile', [ build(social_networks) ], 'POST'
    end

    def self.update(social_network)
      validate([social_network])
      send_request "SocialService.svc/rest/Profile/#{social_network[:type]}/#{social_network[:id]}", [ build([social_network]) ], 'PUT'
    end

    def self.delete(social_network_type, social_network_id)
      send_request "SocialService.svc/rest/Profile/#{social_network_type}/#{social_network_id}", [], 'DELETE'
    end

    private

    def validate(social_networks)
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

    def build(social_networks)
      social_network_data = {
        SocialNetworks: []
      }

      social_networks.each do | social_network |
        social_network_data[:SocialNetworks].push({
          Type: social_network[:type],
          Id: social_network[:Id],
          ShortTermAccessToken: social_network[:short_term_token],
          LongTermAccessToken: social_network[:long_term_token],
          ShortTermExpiry: "\/Date(#{short_term_expiry})\/",
          LongTermExpiry: "\/Date(#{long_term_expiry})\/",
          Secret: social_network[:secret]
        })
      end

      social_networks
    end
  end
end