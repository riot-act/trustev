require 'digest'

module Trustev
  class DigitalSignature

    def initialize(digital_signature, timestamp, session_id, stage_1='')

      raise Error.new('No Username provided.') unless Trustev.username
      raise Error.new('No Password provided.') unless Trustev.password
      raise Error.new('No Shared Secret provided.') unless Trustev.shared_secret
      raise Error.new('No Private Key provided.') unless Trustev.private_key

      @digital_signature = digital_signature
      @timestamp = timestamp
      @session_id = session_id
      @stage_1 = stage_1
      @stage_1 = ".#{stage_1}" unless @stage_1.empty?
    end

    def valid?
      unless Trustev.public_key.nil?
        begin
          response = HTTParty.get("https://js.trustev.com/v1.2/Trustev.js?key=#{Trustev.public_key}")
          raise Error.new('Invalid Public Key') if response.code == 401
          return true if response.code != 200
        rescue Errno::ECONNREFUSED
          return true
        end
      end
      build_signature == @digital_signature
    end

    def invalid?
      !valid?
    end

    private

    def build_signature
      sha256 = Digest::SHA256.new
      sha256 << "#{Trustev.username}.#{Trustev.private_key}.#{@timestamp}#{@stage_1}"
      stage_2 = sha256.hexdigest

      sha256 = Digest::SHA256.new
      sha256 << "#{stage_2}.#{Trustev.private_key}.#{@session_id}"
      sha256.hexdigest
    end
  end
end
